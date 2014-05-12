//
//  AtomStsz.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomStsz.h"

@implementation AtomStsz

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"stsz");
}

- (NSString *)atomName
{
    return (@"Sample Size");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
