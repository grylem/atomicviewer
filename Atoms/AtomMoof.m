//
//  AtomMoof.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMoof.h"

@implementation AtomMoof

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"moof");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Movie Fragment",
                                      @"atomName",
                                      @"Atom moof name");
}

@end
