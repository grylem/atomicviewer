//
//  AtomSmhd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomSmhd.h"

@implementation AtomSmhd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"smhd");
}

+(NSString *)atomName
{
    return (@"Sound Media Header");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
