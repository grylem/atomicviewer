//
//  AtomMehd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMehd.h"

@implementation AtomMehd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mehd");
}

- (NSString *)atomName
{
    return (@"Movie Extends Header");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
