//
//  AtomDesc.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomDesc.h"

@implementation AtomDesc

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"desc");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Description",
                                      @"atomName",
                                      @"Atom desc name");
}

@end
