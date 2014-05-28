//
//  AtomUdta.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomUdta.h"

@implementation AtomUdta

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"udta");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"User Data",
                                      @"atomName",
                                      @"Atom udta name");
}

@end
