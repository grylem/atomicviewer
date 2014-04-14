//
//  AtomMvhd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMvhd.h"

@implementation AtomMvhd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mvhd");
}

+(NSString *)atomName
{
    return (@"Movie Header");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
