//
//  AtomFlvr.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomFlvr.h"

@implementation AtomFlvr

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"flvr");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Flavor",
                                      @"atomName",
                                      @"Atom flvr name");
}

@end
