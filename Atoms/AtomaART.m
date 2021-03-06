//
//  AtomaART.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomaART.h"

@implementation AtomaART

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"aART");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Album Artist",
                                      @"atomName",
                                      @"Atom aART name");
}

@end
