//
//  AtomEnof.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/27/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomEnof.h"

@implementation AtomEnof

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"enof");
}

- (NSString *)atomName
{
    return (@"Track Encoded Pixels Dimensions");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
