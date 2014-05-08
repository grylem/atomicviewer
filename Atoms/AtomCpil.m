//
//  AtomCpil.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomCpil.h"

@implementation AtomCpil

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"cpil");
}

+(NSString *)atomName
{
    return (@"Compilation");
}

- (NSString *)html
{
    return [self asBooleanString];
}

@end
