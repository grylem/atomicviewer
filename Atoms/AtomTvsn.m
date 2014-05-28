//
//  AtomTvsn.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTvsn.h"

@implementation AtomTvsn

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"tvsn");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"TV Season Number",
                                      @"atomName",
                                      @"Atom tvsn name");
}

@end
