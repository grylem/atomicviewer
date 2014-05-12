//
//  AtomTvsh.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTvsh.h"

@implementation AtomTvsh

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"tvsh");
}

- (NSString *)atomName
{
    return (@"TV Show Name");
}

@end
