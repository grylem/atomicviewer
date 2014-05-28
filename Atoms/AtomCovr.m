//
//  AtomCovr.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomCovr.h"

@implementation AtomCovr

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"covr");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Cover Art",
                                      @"atomName",
                                      @"Atom covr name");
}

// short-circuit superclass html string generation. We're an image, we don't need an html string.
- (NSString *)html
{
    return nil;
}

@end
