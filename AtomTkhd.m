//
//  AtomTkhd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTkhd.h"

typedef enum : off_t {
    trakNumberOffset = 20
} offsets;

@implementation AtomTkhd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"tkhd");
}

+(NSString *)atomName
{
    return (@"Track Header");
}

-(BOOL)isFullBox
{
    return YES;
}

-(instancetype) initWithLength: (size_t)atomLength
                    dataOffset: (off_t)offset
                    isExtended: (BOOL)isExtendedLength
               usingFileHandle: (NSFileHandle *)fileHandle
                    withParent: (Atom *)parent
{
    self = [super initWithLength: atomLength
                      dataOffset: offset
                      isExtended: isExtendedLength
                 usingFileHandle: fileHandle
                      withParent: parent];
    if (self) {
        _trakNumber = NSUIntegerMax; // init trakNumber to a sentinel value so we know if it's been set yet or not
    }
    return self;
}

-(NSUInteger)trakNumber
{
    if (_trakNumber == NSUIntegerMax) {
        [self.fileHandle seekToFileOffset:self.origin + trakNumberOffset];
        NSData *fileData = [self.fileHandle readDataOfLength:(sizeof(uint32_t))];
        _trakNumber = CFSwapInt32BigToHost (*(uint32_t *)[fileData bytes]);
    }
    return _trakNumber;
}

@end
