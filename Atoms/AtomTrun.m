//
//  AtomTrun.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTrun.h"

@implementation AtomTrun

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"trun");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Track Fragment Run",
                                      @"atomName",
                                      @"Atom trun name");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
