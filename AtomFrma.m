//
//  AtomFrma.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomFrma.h"

@implementation AtomFrma

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"frma");
}

+(NSString *)atomName
{
    return (@"Original Format");
}

@end
