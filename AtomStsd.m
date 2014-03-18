//
//  AtomStsd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomStsd.h"

@implementation AtomStsd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"stsd");
}

-(BOOL)isFullBox
{
    return YES;
}

-(NSUInteger) jump
{
    // stsd atoms have a four byte "entry count" before the children atoms
    return 4;
}

@end
