//
//  Atom©gen.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom©gen.h"

@implementation Atom_gen

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"©gen");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Genre",
                                      @"atomName",
                                      @"Atom ©cgen name");
}

@end
