//
//  AtomCtts.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomCtts.h"

@implementation AtomCtts

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"ctts");
}

- (NSString *)atomName
{
    return (@"Composition Time to Sample");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
