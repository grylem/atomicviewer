//
//  AtomStts.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomStts.h"

@implementation AtomStts

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"stts");
}

+(NSString *)atomName
{
    return (@"Decoding Time to Sample");
}

@end
