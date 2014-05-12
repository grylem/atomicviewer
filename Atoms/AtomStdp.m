//
//  AtomStdp.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomStdp.h"

@implementation AtomStdp

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"stdp");
}

- (NSString *)atomName
{
    return (@"Degradation Priority");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
