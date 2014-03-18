//
//  AtomAc-3.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomAc-3.h"

@implementation AtomAc_3

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"ac-3");
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
