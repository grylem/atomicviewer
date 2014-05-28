//
//  AtomTfra.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTfra.h"

@implementation AtomTfra

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"tfra");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Track Fragment Random Access",
                                      @"atomName",
                                      @"Atom tfra name");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
