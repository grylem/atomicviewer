//
//  AtomIviv.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/23/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomIviv.h"

@implementation AtomIviv

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"iviv");
}

@end
