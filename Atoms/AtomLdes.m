//
//  AtomLdes.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomLdes.h"

@implementation AtomLdes

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"ldes");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Long Description",
                                      @"atomName",
                                      @"Atom ldes name");
}

@end
