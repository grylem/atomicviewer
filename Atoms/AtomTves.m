//
//  AtomTves.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTves.h"

@implementation AtomTves

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"tves");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"TV Episode Number in Season",
                                      @"atomName",
                                      @"Atom tves name");
}

@end
