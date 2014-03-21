//
//  AtomCprt.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomCprt.h"

@implementation AtomCprt

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"cprt");
}

+(NSString *)atomName
{
    return (@"Copyright");
}

@end
