//
//  Atom©day.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom©day.h"

@implementation Atom_day

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"©day");
}

+(NSString *)atomName
{
    return (@"Recorded Date");
}

@end
