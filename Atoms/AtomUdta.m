//
//  AtomUdta.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomUdta.h"

@implementation AtomUdta

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"udta");
}

+(NSString *)atomName
{
    return (@"User Data");
}

// Historically, Quicktime files may have udta atoms
// with a zero-terminated list of children (rather
// than being driven by size). Make sure we don't have
// just an empty, zero-terminated list by ensuring we have enough
// room to accommodate children before looking for them.

-(BOOL) isLeaf
{
    return self.dataLength == 12;
}

@end
