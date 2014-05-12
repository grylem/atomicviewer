//
//  AtomMeta.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMeta.h"

@implementation AtomMeta

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"meta");
}

- (NSString *)atomName
{
    return (@"Metadata");
}

// Some Quicktime files may be typed as MPEG-4,
// in which case, the metadata layout is different.
// Make sure we treat meta as a "full box" only if
// it appears as part of the MPEG-4 iTunes metadata
// path.
// If it appears elsewhere, we're not sure what
// the format is.

-(BOOL) isFullBox
{
    return [self isDescendantOf:@"moov.udta"];
}

@end
