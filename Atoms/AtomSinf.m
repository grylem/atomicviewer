//
//  AtomSinf.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomSinf.h"

@implementation AtomSinf

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"sinf");
}

+(NSString *)atomName
{
    return (@"Protection Scheme Information");
}

@end
