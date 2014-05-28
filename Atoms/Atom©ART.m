//
//  Atom©ART.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom©ART.h"

@implementation Atom_ART

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"©ART");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Artist",
                                      @"atomName",
                                      @"Atom ©ART name");
}

@end
