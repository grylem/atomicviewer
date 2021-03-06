//
//  AtomNmhd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomNmhd.h"

@implementation AtomNmhd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"nmhd");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Null Media Header",
                                      @"atomName",
                                      @"Atom nmhd name");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
