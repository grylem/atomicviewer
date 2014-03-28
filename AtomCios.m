//
//  AtomCios.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/27/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomCios.h"

@implementation AtomCios

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"cios");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
