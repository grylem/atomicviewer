//
//  AtomEsds.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomEsds.h"

@implementation AtomEsds

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"esds");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
