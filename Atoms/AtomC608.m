//
//  AtomC608.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/23/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomC608.h"

@implementation AtomC608

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"c608");
}

-(BOOL)isFullBox
{
    return YES;
}

-(NSUInteger) jump
{
    // not sure what this is (yet)
    return 4;
}

@end
