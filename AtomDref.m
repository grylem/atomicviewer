//
//  AtomDref.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomDref.h"

@implementation AtomDref

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"dref");
}

+(NSString *)atomName
{
    return (@"Data Reference");
}

-(BOOL)isFullBox
{
    return YES;
}

-(NSUInteger) jump
{
    // dref atoms have a four byte "entry count" before the children atoms
    return 4;
}

@end
