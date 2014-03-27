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

#pragma mark - Class cluster mapping

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

#pragma mark - Class methods

//  Convenience method to create a new atom.
//  Atoms are a class cluster, so this method looks up the real class in the atomToClassDict
//  and creates an instance of the class found there. An instance of AtomUnrecognized is created
//  if the atom type is not found in atomToClassDict.
//  The new instance is initialized with:
//  • The 4-character atomType
//  • The real length of the entire atom (including length & type fields)
//  • The offset within the file where this atom is located
//  • A flag indicating if this atom uses a 32-bit or 64-bit length field
//  • The dispatch_io channel used for reading atom contents
//  • The GCD queue on which asynchronous reads should occur
//  • The tree controller controlling the outline in which this atom will be stored

+ (Atom *)createAtomOfType: (NSString *)atomType withLength: (size_t)atomLength fromOffset: (off_t)offset isExtended: (BOOL)isExtendedLength usingFileHandle:fileHandle
{
    Class atomClass = atomToClassDict[atomType];
    Atom *newAtom;

    if (atomClass) {
        newAtom = [[atomClass alloc] initWithLength: atomLength dataOffset: offset isExtended: isExtendedLength usingFileHandle:fileHandle];
    } else {
        newAtom = [[AtomUnrecognized alloc] initWithType: atomType length: atomLength dataOffset: offset isExtended: isExtendedLength usingFileHandle:fileHandle];
    }
    return newAtom;
}

//  This is the primary means of creating atoms.
//  This will create all the atoms at a specific level in the atom hierarchy
+ (void)populateOutline:(NSMutableArray *)contents fromFileHandle: (NSFileHandle *)fileHandle atOffset:(off_t)offset upTo:(off_t)end {

    size_t actualSize;
    char atomType[5];
    BOOL isExtendedLength = NO;
    NSString *atomTypeString;
    Atom *atom;

    [fileHandle seekToFileOffset: offset];
    NSData *fileData = [fileHandle readDataOfLength:8];

    // We've read 8 bytes: length & atom type
    // byteswap the length & copy the atom type to a C string
    uint32_t size = CFSwapInt32BigToHost (*(uint32_t *)[fileData bytes]);
    actualSize = size;

    memcpy(&atomType, &[fileData bytes][4], 4); // turn the 4-byte atom type into a null-terminated C string.
    atomType[4] = '\0';

    // If extended length, read next 8 bytes to get the real atom length
    if (size == 1) {
        isExtendedLength = YES;

        // Read the extended length synchronously
        [fileHandle seekToFileOffset: offset + 8];

        NSData *largeSize = [fileHandle readDataOfLength:sizeof(size_t)];
        actualSize = CFSwapInt64BigToHost(*(uint64_t *)[largeSize bytes]);

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
    atom = [self createAtomOfType: atomTypeString
                       withLength: actualSize
                       fromOffset: offset
                       isExtended: isExtendedLength
                  usingFileHandle: fileHandle];

    if ([atom isFullBox]) {
        off_t versionOffset;
        versionOffset = offset + 8; // Nominally right after size & type
        if (isExtendedLength) {
            versionOffset += 8; // But if it's extendedLength, version is later
        }
        [fileHandle seekToFileOffset: versionOffset];
        NSData *versionData = [fileHandle readDataOfLength:sizeof(uint64_t)];
        // break the four bytes into 3 byte flags and 1 byte version
        // set flags & version in atom
    }

    [contents addObject:atom];

    // if ((offset + actualSize) < end) { // offset + wholeAtomLength is next atom
    // offset + actualSize is beginning of next atom
    // But there may be garbage at end of file.
    // Check that we can actually read an atom header by adding 8 to offset + actualSize
    if (end >= (offset + actualSize + 8)) { // offset + wholeAtomLength is next atom.
        [self populateOutline: contents
               fromFileHandle: fileHandle
                     atOffset: (offset + actualSize)
                         upTo: end];
    }
}

//  The 4-character atomType is usually answered by the Class.
//  But this abstract superclass does not have an atomType
+ (NSString *)atomType
{
    return nil; // The abstact superclass does not have an atomType
}

//  This is the human-readable atomName.
//  But this abstract superclass does not have an atomName
+(NSString *)atomName
{
    return nil;
}

#pragma mark - Instance methods

//  Designated initializer for the Atom class cluster (except AtomUnrecognized)
//  This is typically invoked by +createAtomOfType:withLength:fromOffset:isExtended:usingFileHandle:inTree:
//  Using the class convenience method for creation handles instantiation of the correct concrete subclass.
-(instancetype) initWithLength: (size_t)atomLength dataOffset: (off_t)offset isExtended: (BOOL)isExtendedLength usingFileHandle:(NSFileHandle *)fileHandle;
{
    self = [super init];
    if (self) {
        self.dataLength = atomLength;
        self.origin = offset;
        self.fileHandle = fileHandle;
        self.extendedLength = isExtendedLength;
    }
    return self;
}

-(NSString *)atomType
{
    return [[self class] atomType];
}

//  This is the human-readable atomName
//  The usual behavior is to get this from our class
//  But if this is an atom we don't understand,
//  the class will return nil. In this case, we simply supply
//  a string explaining that we don't know about this atom
- (NSString *)atomName
{
    return [[self class] atomName] ? [[self class] atomName] : @"The meaning of this atom is unknown.";
}

-(BOOL) isLeaf
{
    return YES;
}

//  YES if this atom type contains version & flags
-(BOOL) isFullBox
{
    return NO;
}

-(NSString *)nodeTitle
{
    // Most subclasses have a 4-character atom type string that is used to as the key to the atomToClassDict.
    // That 4-character atom type is also usually what we want displayed in the outline.
    // Some subclasses will override this, such as the "unrecognized" atom class that we just skip over, and
    // the uuid type atoms that will supply the formatted uuid string.
    
    return [self atomType];
}

-(NSUInteger)nodeOrigin
{
    return self.origin;
}

-(NSUInteger)nodeLength
{
    return self.dataLength;
}

-(NSUInteger)nodeEnd
{
    return self.origin + self.dataLength;
}

-(NSString *)description
{
    return [NSString stringWithFormat: @"Atom type %@ of size %zu", [self atomType], [self dataLength]];
}

-(NSAttributedString *)explanation
{
    // Create Font and ParagraphStyle objects
    NSFont* headerFont = [NSFont fontWithName:@"AvenirNext-Bold" size:24.0];
    NSFont* bodyFont = [NSFont fontWithName:@"AvenirNext-Medium" size:14.0];
    NSMutableParagraphStyle* myStringParaStyle1 = [NSMutableParagraphStyle new];
    myStringParaStyle1.alignment = NSCenterTextAlignment; // Header & sub-header will be centered

    // Get the string to use for the Atom Type header
    NSString *headerString = [NSString stringWithFormat:@"Atom %@\n", [self atomType]];
    NSRange headerRange = NSMakeRange(0, [headerString length]);

    // Get the string to use for the Atom Name sub-header
    NSString *subHeaderString = [self atomName];
    NSRange subHeaderRange = NSMakeRange([headerString length], [subHeaderString length]);

    // Concatenate the header & sub-header
    NSString *completeString = [headerString stringByAppendingString:subHeaderString];
    NSRange completeRange = NSMakeRange(0, [completeString length]);

    // Turn the NSString into a NSMutableAttributedString so we can apply attributes to it
    NSMutableAttributedString *explanatoryString = [[NSMutableAttributedString alloc] initWithString: completeString];

    // Apply our ParagraphStyle to the whole thing
    [explanatoryString addAttribute:NSParagraphStyleAttributeName value:myStringParaStyle1 range:completeRange];

    // Apply the header font to the header
    [explanatoryString addAttribute:NSFontAttributeName value:headerFont range:headerRange];

    // Underline the Atom Type header
    [explanatoryString addAttribute:NSUnderlineStyleAttributeName value:@1 range:headerRange];

    // Apply the sub-header font to the sub-header
    [explanatoryString addAttribute:NSFontAttributeName value:bodyFont range:subHeaderRange];

    [explanatoryString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];

    NSAttributedString* decodedExplanation = [self decodedExplanation];

    if (decodedExplanation) {
        [explanatoryString appendAttributedString:decodedExplanation];
    }

    return explanatoryString;
}

//  This is the formatted textual explantion of the content of the atom
- (NSAttributedString *)decodedExplanation
{
    return nil; // The abstract superclass does not have a decodedExplanation
}

@end
