//
//  AtomStsh.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomStsh.h"

@implementation AtomStsh

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"stsh");
}

+(NSString *)atomName
{
    return (@"Shadow Sync Sample");
}

@end
