//
//  AtomTven.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTven.h"

@implementation AtomTven

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"tven");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"TV Episode Number",
                                      @"atomName",
                                      @"Atom tven name");
}

@end
