//
//  AtomSkip.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomSkip.h"

@implementation AtomSkip

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"skip");
}

- (NSString *)atomName
{
    return (@"Free Space");
}

@end
