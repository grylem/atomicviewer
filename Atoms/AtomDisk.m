//
//  AtomDisk.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomDisk.h"

// These are offsets within my child 'data' atom
typedef enum : off_t {
    size = 0,
    type = 4,
    datatype = 8,
    locale = 12,
    reserved1 = 16,
    disknumber = 18, // -12
    totaldisks = 20  // -12
} offsets;

@implementation AtomDisk

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"disk");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Disk Number",
                                      @"atomName",
                                      @"Atom disk name");
}

-(UInt16)diskNumber
{
    if (!_diskNumber) {
        _diskNumber = [self getUInt16ValueAtOffset:6];
    }
    return _diskNumber;
}

-(UInt16)totalDisks
{
    if (!_totalDisks) {
        _totalDisks = [self getUInt16ValueAtOffset:8];
    }
    return _totalDisks;
}

- (NSString *)html
{
    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      Disk %@ of %@\
                      </p></span></body>",
                      @(self.diskNumber),
                      @(self.totalDisks)];
    return html;
}

@end
