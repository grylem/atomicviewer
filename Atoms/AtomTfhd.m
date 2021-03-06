//
//  AtomTfhd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTfhd.h"

@implementation AtomTfhd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"tfhd");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Track Fragment Header",
                                      @"atomName",
                                      @"Atom tfhd name");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
