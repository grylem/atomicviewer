//
//  AtomDac3.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomDac3.h"

@implementation AtomDac3

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"dac3");
}

@end
