//
//  AtomPlID.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomPlID.h"

@implementation AtomPlID

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"plID");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Playlist ID",
                                      @"atomName",
                                      @"Atom plID name");
}

@end
