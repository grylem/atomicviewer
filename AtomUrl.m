//
//  AtomUrl.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomUrl.h"

@implementation AtomUrl

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"url ");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
