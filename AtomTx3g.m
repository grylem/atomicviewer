//
//  AtomTx3g.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/23/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTx3g.h"

@implementation AtomTx3g

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"tx3g");
}

-(BOOL)isFullBox
{
    return YES;
}

-(NSUInteger) jump
{
    // not sure what this is (yet)
    return 34;
}

@end
