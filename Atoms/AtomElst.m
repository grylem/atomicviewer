//
//  AtomElst.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomElst.h"

@implementation AtomElst

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"elst");
}

- (NSString *)atomName
{
    return (@"Edit List");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
