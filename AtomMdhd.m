//
//  AtomMdhd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMdhd.h"

@implementation AtomMdhd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mdhd");
}

+(NSString *)atomName
{
    return (@"Media Header");
}

@end
