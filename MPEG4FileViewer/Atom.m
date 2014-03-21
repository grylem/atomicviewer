//
//  Atom.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom.h"
#import "AtomUnrecognized.h"

@interface Atom ()


@end

@implementation Atom

static NSMutableDictionary *atomToClassDict;
static dispatch_once_t pred;

// HERE BE DRAGONS
// My subclasses invoke this during their +load. BE CAREFUL
// This is ONLY for subclasses to populate the atom type to Class dictionary.
// Do not use for any other purpose, as heavy lifting during +load is EXTREMELY dangerous.
// Note, +initialize cannot be used, as +initialize is invoked lazily before first message sent to the class
// If we don't have the Class in the atomToClassDict, it'll never get messages, so +initilize will never be invoked.

+ (void)populateAtomToClassDict
{
    dispatch_once (&pred, ^{
        atomToClassDict = [NSMutableDictionary new];
    });
    
    if (self != [Atom class]) {
        [atomToClassDict setValue: [self class] forKey:[self atomType]];
    }
}

+ (NSString *)atomType
{
    return nil; // The abstact superclass does not have an atomType
}

+(NSString *)atomName
{
    return nil; // The abstract superclass does not have an atomName
}

- (NSString *)atomName
{
    return [[self class] atomName] ? [[self class] atomName] : @"This type of atom is unknown.";
}

+ (Atom *)createAtomOfType: (NSString *)atomType withLength: (size_t)atomLength fromOffset: (off_t)offset isExtended: (BOOL)isExtendedLength usingChannel: (dispatch_io_t)channel onQueue: (dispatch_queue_t)queue inTree: (NSTreeController *)treeController
{
    Class atomClass = atomToClassDict[atomType];
    Atom *newAtom;
    if (atomClass) {
        newAtom = [[atomToClassDict[atomType] alloc] initWithLength: atomLength dataOffset: offset isExtended: isExtendedLength usingChannel: channel onQueue: queue inTree: treeController];
    } else {
        newAtom = [[AtomUnrecognized alloc] initWithType: atomType length: atomLength dataOffset: offset isExtended: isExtendedLength usingChannel: channel onQueue:queue inTree: treeController];
    }
    return newAtom;
}

+ (void)populateTree: (NSTreeController *)treeController childOf:(NSIndexPath *)indexPath atIndex: (NSInteger)index fromChannel: (dispatch_io_t)channel onQueue: (dispatch_queue_t)queue atOffset: (off_t)offset upTo: (off_t)end
{
    dispatch_io_read(channel,
                     offset,
                     8, // Length of size & type
                     queue,
                     ^(bool done, dispatch_data_t data, int error) {
                         const void *buffer = NULL;
                         size_t length = 0;
                         size_t actualSize;
                         Atom *atom;
                         char atomType[5];
                         NSIndexPath *indexPathToAdd;
                         NSString *atomTypeString;
                         BOOL isExtendedLength = NO;
                         if (error == 0) {
                             // I don't care about the returned tmpData. Just need the buffer.
                             __unused dispatch_data_t tmpData = dispatch_data_create_map(data,
                                                                                         &buffer,
                                                                                         &length);
                         }
                         // We've read 8 bytes: length & atom type
                         // byteswap the length & copy the atom type to a C string
                         uint32_t size = CFSwapInt32BigToHost (*(uint32_t *)buffer);
                         actualSize = size;
                         
                         memcpy(&atomType, &buffer[4], 4); // turn the 4-byte atom type into a null-terminated C string.
                         atomType[4] = '\0';
                         
                         // If extended length, read next 8 bytes to get the real atom length
                         if (size == 1) {
                             isExtendedLength = YES;
                             // Read the extended length synchronously
                             dispatch_fd_t fd = dispatch_io_get_descriptor(channel);
                             lseek(fd, offset + 8, SEEK_SET); // Seek right after size & type
                             uint64_t largeSize;
                             read(fd, &largeSize, sizeof(largeSize));
                             actualSize = CFSwapInt64BigToHost(largeSize);
                         } else if (size == 0) {
                             // This had better only occur at the top level (i.e., 'end' is end-of-file)
                             // Check assertion that indexPath is nil
                             actualSize = end - offset;
                         }
                         
                         // Use ISO Latin-1 encoding for the atom type string.
                         // ISO Latin-1 decodes © symbol present in some atom type strings.
                         atomTypeString = [NSString stringWithCString:atomType encoding:NSISOLatin1StringEncoding];
                         
                         // Now that we have the length & type, go ahead and create the atom
                         // The returned atom will be a concrete subclass of Atom
                         atom = [self createAtomOfType: atomTypeString withLength: actualSize fromOffset: offset isExtended: isExtendedLength usingChannel: channel onQueue:queue inTree: treeController];
                         
                         // Set the indexPath where this atom will be located in the treeController
                         // I'm not crazy about this approach, but there seems to be no way to find
                         // a specific entry in the tree from the treeController if you don't
                         // a priori have the indexPath
                         if (!indexPath) {
                             indexPathToAdd = [NSIndexPath indexPathWithIndex: index];
                         } else {
                             indexPathToAdd = [indexPath indexPathByAddingIndex:index];
                         }
                         [atom setIndexPath: indexPathToAdd];
                         if ([atom isFullBox]) {
                             uint64_t version;
                             dispatch_fd_t fd = dispatch_io_get_descriptor(channel);
                             off_t versionOffset;
                             versionOffset = offset + 8; // Nominally right after size & type
                             if (isExtendedLength) {
                                 versionOffset += 8; // But if it's extendedLength, version is later
                             }
                             lseek(fd, versionOffset, SEEK_SET);
                             read(fd, &version, sizeof(version));
                             // break the four bytes into 3 byte flags and 1 byte version
                             // set flags & version in atom
                         }
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [treeController insertObject:atom  atArrangedObjectIndexPath:indexPathToAdd];
                         });
//                         if ((offset + actualSize) < end) { // offset + wholeAtomLength is next atom
                         // offset + actualSize is beginning of next atom
                         // But there may be garbage at end of file.
                         // Check that we can actually read an atom header by adding 8 to offset + actualSize
                         if (end >= (offset + actualSize + 8)) { // offset + wholeAtomLength is next atom.
                             [self populateTree:treeController childOf: indexPath atIndex: index + 1 fromChannel:channel onQueue:queue atOffset:(offset + actualSize) upTo:end];
                         }
                     });
}

-(BOOL) isLeaf
{
    return YES;
}

-(void)setIsLeaf:(BOOL)isLeaf
{
    
}

-(BOOL) isFullBox
// YES if this atom type contains version & flags
{
    return NO;
}

-(NSString *)nodeTitle
{
    // Most subclasses have a 4-character atom type string that is used to as the key to the atomToClassDict.
    // That 4-character atom type is also usually what we want displayed in the outline.
    // Some subclasses will override this, such as the "unrecognized" atom class that we just skip over, and
    // the uuid type atoms that will supply the formatted uuid string.
    
    return ([NSString stringWithFormat:@"Atom %@ @ %lld of size: %zu, ends @ %lld", [[self class] atomType], self.origin, self.dataLength, self.origin + self.dataLength]);
//    return [[self class] atomType];
}

-(NSString *)description
{
    return [NSString stringWithFormat: @"Atom type %@ of size %zu", [[self class] atomType], [self dataLength]];
}

-(instancetype) initWithLength: (size_t)atomLength dataOffset: (off_t)offset isExtended: (BOOL)isExtendedLength usingChannel: (dispatch_io_t)channel onQueue:(dispatch_queue_t)queue inTree:(NSTreeController *)treeController;
{
    self = [super init];
    if (self) {
        self.dataLength = atomLength;
        self.origin = offset;
        self.io_channel = channel;
        self.queue = queue;
        self.treeController = treeController;
        self.extendedLength = isExtendedLength;
    }
    return self;
}

-(NSAttributedString *)explanation
{
    NSFont* headerFont = [NSFont fontWithName:@"AvenirNext-Bold" size:24.0];
    NSFont* bodyFont = [NSFont fontWithName:@"AvenirNext-Medium" size:12.0];

    NSString *headerString = [NSString stringWithFormat:@"Atom %@\n", [[self class] atomType]];
    NSRange headerRange = NSMakeRange(0, [headerString length]);

    NSString *bodyString = [self atomName];
    NSRange bodyRange = NSMakeRange([headerString length], [bodyString length]);

    NSString *completeString = [headerString stringByAppendingString:bodyString];
    NSRange completeRange = NSMakeRange(0, [completeString length]);

    NSMutableAttributedString *explanatoryString = [[NSMutableAttributedString alloc] initWithString: completeString];

    NSMutableParagraphStyle* myStringParaStyle1 = [NSMutableParagraphStyle new];
    myStringParaStyle1.alignment = NSCenterTextAlignment;
    [explanatoryString addAttribute:NSParagraphStyleAttributeName value:myStringParaStyle1 range:completeRange];
    [explanatoryString addAttribute:NSFontAttributeName value:headerFont range:headerRange];
    [explanatoryString addAttribute:NSUnderlineStyleAttributeName value:@1 range:headerRange];
    [explanatoryString addAttribute:NSFontAttributeName value:bodyFont range:bodyRange];

    return explanatoryString;
}

@end
