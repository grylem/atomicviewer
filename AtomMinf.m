//
//  AtomMinf.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMinf.h"

@implementation AtomMinf

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"minf");
}

+(NSString *)atomName
{
    return (@"Media Information");
}

@end
