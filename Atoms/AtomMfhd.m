//
//  AtomMfhd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMfhd.h"

@implementation AtomMfhd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mfhd");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Movie Fragment Header",
                                      @"atomName",
                                      @"Atom mfhd name");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
