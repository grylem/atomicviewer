//
//  Atom©alb.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom©alb.h"

@implementation Atom_alb

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"©alb");
}

- (NSString *)atomName
{
    return (@"Album");
}

@end
