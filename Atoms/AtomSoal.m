//
//  AtomSoal.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomSoal.h"

@implementation AtomSoal

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"soal");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Sort Order Album",
                                      @"atomName",
                                      @"Atom soal name");
}

@end
