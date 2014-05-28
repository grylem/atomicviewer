//
//  AtomMehd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMehd.h"

@implementation AtomMehd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mehd");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Movie Extends Header",
                                      @"atomName",
                                      @"Atom mehd name");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
