//
//  AtomMdat.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMdat.h"

@implementation AtomMdat

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mdat");
}

- (NSString *)atomName
{
    return (@"Media Data");
}

//  This is the formatted textual explantion of the content of the atom
- (NSString *)html
{
    return @"Movie sample data";
}

@end
