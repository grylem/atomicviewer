//
//  AtomMeta.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMeta.h"

@implementation AtomMeta

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"meta");
}

-(BOOL) isLeaf
{
    return NO;
}

-(NSUInteger) jump
{
    return 4; // The meta atom has a fixed data size before the children atoms
}

@end
