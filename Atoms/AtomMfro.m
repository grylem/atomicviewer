//
//  AtomMfro.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMfro.h"

@implementation AtomMfro

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mfro");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Movie Fragment Random Access Offset",
                                      @"atomName",
                                      @"Atom mfro name");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
