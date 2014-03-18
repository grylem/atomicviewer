//
//  AtomMean.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMean.h"

@implementation AtomMean

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mean");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
