//
//  AtomFree.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomFree.h"

@implementation AtomFree

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"free");
}

- (NSString *)atomName
{
    return (@"Free Space");
}

@end
