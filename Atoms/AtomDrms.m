//
//  AtomDrms.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomDrms.h"

@implementation AtomDrms

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"drms");
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
