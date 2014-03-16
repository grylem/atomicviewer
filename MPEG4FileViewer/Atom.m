//
//  Atom.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom.h"
#import "AtomUnrecognized.h"
#import "AppDelegate.h"  // HACK

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

+ (Atom *)createAtomOfType: (NSString *)atomType withLength: (size_t)atomLength fromOffset: (off_t)offset usingChannel: (dispatch_io_t)channel onQueue: (dispatch_queue_t)queue
{
    Class atomClass = atomToClassDict[atomType];
    Atom *newAtom;
    if (atomClass) {
        newAtom = [[atomToClassDict[atomType] alloc] initWithLength: atomLength dataOffset: offset usingChannel: channel onQueue:queue];
    } else {
        newAtom = [[AtomUnrecognized alloc] initWithType: atomType length: atomLength dataOffset: offset usingChannel: channel onQueue:queue];
    }
    return newAtom;
}

+ (void)populateContents: (NSMutableArray *)atomArray fromChannel: (dispatch_io_t)channel onQueue: (dispatch_queue_t)queue atOffset: (off_t)offset upTo: (off_t)end
{
    dispatch_io_read(channel,
                     offset,
                     8,
                     queue,
                     ^(bool done, dispatch_data_t data, int error) {
                         const void *buffer = NULL;
                         off_t dataOffset = 0;
                         size_t length = 0;
                         size_t wholeAtomLength;
                         Atom *atom;
                         char atomType[5];
                         if (error == 0) {
                             // I don't care about the returned tmpData. Just need the buffer.
                             __unused dispatch_data_t tmpData = dispatch_data_create_map(data,
                                                                                         &buffer,
                                                                                         &length);
                             dataOffset = offset + length;
                         }
                         // We've read 8 bytes: length & atom type
                         // byteswap the length & copy the atom type to a C string
                         uint32_t atomLength = CFSwapInt32BigToHost (*(uint32_t *)buffer);
                         wholeAtomLength = atomLength;
                         
                         memcpy(&atomType, &buffer[4], 4); // turn the 4-byte atom type into a null-terminated C string.
                         atomType[4] = '\0';
                         
                         if (atomLength == 1) {
                             // Read the extended length synchronously
                             dispatch_fd_t fd = dispatch_io_get_descriptor(channel);
                             lseek(fd, dataOffset, SEEK_SET);
                             uint64_t extendedAtomLength;
                             read(fd, &extendedAtomLength, sizeof(extendedAtomLength));
                             length += sizeof(extendedAtomLength);
                             dataOffset += sizeof(extendedAtomLength);
                             wholeAtomLength = CFSwapInt64BigToHost(extendedAtomLength);
                         }
                         // Note the use of "@(atomType)". This is an Objective-C 2.0 boxed C String
                         atom = [self createAtomOfType: @(atomType) withLength: wholeAtomLength-length fromOffset: dataOffset usingChannel: channel onQueue:queue];
                         [atomArray addObject: atom];
                         if ((offset + wholeAtomLength) < end) {
                             [self populateContents:atomArray fromChannel:channel onQueue:queue atOffset:(offset + wholeAtomLength) upTo:end];
                         }
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [(AppDelegate *)([NSApp delegate]) reloadOutlineView]; // HACK
                         });
                     });
}

-(BOOL) isLeaf
{
    return YES;
}

-(void)setIsLeaf:(BOOL)isLeaf
{
    
}

-(NSString *)nodeTitle
{
    // Most subclasses have a 4-character atom type string that is used to as the key to the atomToClassDict.
    // That 4-character atom type is also usually what we want displayed in the outline.
    // Some subclasses will override this, such as the "unrecognized" atom class that we just skip over, and
    // the uuid type atoms that will supply the formatted uuid string.
    return [[self class] atomType];
}

-(NSString *)description
{
    return [NSString stringWithFormat: @"Atom type %@ of size %zu", [self nodeTitle], [self dataLength]];
}

-(instancetype) initWithLength: (size_t)atomLength dataOffset: (off_t)offset usingChannel: (dispatch_io_t)channel onQueue:(dispatch_queue_t)queue;
{
    self = [super init];
    if (self) {
        self.dataLength = atomLength;
        self.fileOffset = offset;
        self.io_channel = channel;
        self.queue = queue;
    }
    return self;
}

@end
