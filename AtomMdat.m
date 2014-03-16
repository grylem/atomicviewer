//
//  AtomMdat.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMdat.h"

@implementation AtomMdat

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mdat");
}

@end
