//
//  AtomMp4a.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMp4a.h"

@implementation AtomMp4a

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mp4a");
}

-(BOOL)isFullBox
{
    return YES;
}

-(NSUInteger) jump
{
    return 24;
}

@end
