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

+(NSString *)atomName
{
    return (@"Metadata");
}

-(BOOL) isLeaf
{
    return NO;
}

-(BOOL) isFullBox
// YES if this atom type contains version & flags
{
    return YES;
}

@end
