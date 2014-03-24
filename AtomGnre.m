//
//  AtomGnre.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/24/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomGnre.h"

@implementation AtomGnre

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"gnre");
}

+(NSString *)atomName
{
    return (@"Genre");
}

@end
