//
//  AtomElng.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomElng.h"

@implementation AtomElng

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"elng");
}

- (NSString *)atomName
{
    return (@"Extended Language Tag");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
