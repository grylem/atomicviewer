//
//  AtomIlst.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomIlst.h"

@implementation AtomIlst

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"ilst");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Metadata Item List",
                                      @"atomName",
                                      @"Atom ilst name");
}

// Some Quicktime files may be typed as MPEG-4,
// in which case the metadata layout is different.
// Ignore Quicktime files for now by short-circuiting
// the descent into ilst.

-(BOOL) isLeaf
{
    return ![self isDescendantOf:@"moov.udta.meta"];
}

@end
