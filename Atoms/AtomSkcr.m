//
//  AtomSkcr.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/23/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomSkcr.h"

@implementation AtomSkcr

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"skcr");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
