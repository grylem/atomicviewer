//
//  AtomTraf.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTraf.h"

@implementation AtomTraf

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"traf");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Track Fragment",
                                      @"atomName",
                                      @"Atom traf name");
}

@end
