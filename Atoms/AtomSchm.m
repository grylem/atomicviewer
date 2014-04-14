//
//  AtomSchm.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomSchm.h"

@implementation AtomSchm

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"schm");
}

+(NSString *)atomName
{
    return (@"Scheme Type");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
