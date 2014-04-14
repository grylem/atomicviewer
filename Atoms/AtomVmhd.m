//
//  AtomVmhd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomVmhd.h"

@implementation AtomVmhd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"vmhd");
}

+(NSString *)atomName
{
    return (@"Video Media Header");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
