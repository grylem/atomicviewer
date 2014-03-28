//
//  Atom©too.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom©too.h"

@implementation Atom_too

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"©too");
}

+(NSString *)atomName
{
    return (@"Encoder");
}

@end
