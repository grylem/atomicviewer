//
//  Atom©wrt.m
//  AtomicViewer
//
//  Created by Jay O'Conor on 4/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom©wrt.h"

@implementation Atom_wrt

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"©wrt");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Movie's Writer",
                                      @"atomName",
                                      @"Atom ©wrt name");
}

@end
