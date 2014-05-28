//
//  AtomMfra.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMfra.h"

@implementation AtomMfra

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mfra");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Movie Fragment Random Access",
                                      @"atomName",
                                      @"Atom mfra name");
}

@end
