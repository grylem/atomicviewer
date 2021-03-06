//
//  AtomStbl.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomStbl.h"

@implementation AtomStbl

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"stbl");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Sample Table",
                                      @"atomName",
                                      @"Atom stbl name");
}

@end
