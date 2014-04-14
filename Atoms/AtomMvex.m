//
//  AtomMvex.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMvex.h"

@implementation AtomMvex

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mvex");
}

+(NSString *)atomName
{
    return (@"Movie Extends");
}

@end
