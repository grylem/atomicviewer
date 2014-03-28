//
//  AtomIods.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomIods.h"

@implementation AtomIods

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"iods");
}

+(NSString *)atomName
{
    return (@"Object Descriptor");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
