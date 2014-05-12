//
//  AtomCo64.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomCo64.h"

@implementation AtomCo64

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"co64");
}

- (NSString *)atomName
{
    return (@"Chunk Large Offset");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
