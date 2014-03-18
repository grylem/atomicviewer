//
//  AtomFall.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomFall.h"

// This is a track reference atom.
// I haven't seen a definition of this atom yet, but given the context in which it's used (tref),
// the data is likely an array of Track IDs

@implementation AtomFall

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"fall");
}

@end
