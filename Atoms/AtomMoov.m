//
//  AtomMoov.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMoov.h"

@implementation AtomMoov

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"moov");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Movie",
                                      @"atomName",
                                      @"Atom moov name");
}

//  This is the formatted textual explantion of the content of the atom
- (NSString *)html
{
    return NSLocalizedString(@"This is the container for the information that describes a movie's data",nil);
}

@end
