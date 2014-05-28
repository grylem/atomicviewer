//
//  AtomTrex.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTrex.h"

@implementation AtomTrex

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"trex");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Track Extends",
                                      @"atomName",
                                      @"Atom trex name");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
