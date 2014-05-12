//
//  AtomHmhd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomHmhd.h"

@implementation AtomHmhd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"hmhd");
}

- (NSString *)atomName
{
    return (@"Hint Media Header");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
