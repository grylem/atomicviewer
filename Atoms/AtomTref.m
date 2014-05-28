//
//  AtomTref.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTref.h"

@implementation AtomTref

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"tref");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Track Reference",
                                      @"atomName",
                                      @"Atom tref name");
}

@end
