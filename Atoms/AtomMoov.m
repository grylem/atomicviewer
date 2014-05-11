//
//  AtomMoov.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMoov.h"

@implementation AtomMoov

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"moov");
}

+(NSString *)atomName
{
    return (@"Movie");
}

//  This is the formatted textual explantion of the content of the atom
- (NSString *)html
{
    return @"This is the container for all the metadata";
}

@end