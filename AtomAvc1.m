//
//  AtomAvc1.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomAvc1.h"

@implementation AtomAvc1

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"avc1");
}

-(NSUInteger) jump
{
    return 78;
}

@end
