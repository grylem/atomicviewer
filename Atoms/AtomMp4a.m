//
//  AtomMp4a.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

// This is defined differently between MPEG4 and Quicktime.
// At offset 16 is a 16-bit value which will be zero for MPEG4
// and one or two for Quicktime.

// We don't fully interpret the contents of this atom (yet).
// But we do need to know where to find the children of this atom.
// Since MPEG4 and QT use different formats, use the discriminator
// described above to figure out the 'jump' value to skip over
// to find the children.

// This still doesn't handle the Quicktime case of a mp4a atom
// inside a wave atom inside a mp4a atom.
// To handle that, I need to check if my parent is an stsd atom.
// If so, jump is 28 or 44.
// If not, then I'm not a leaf.
#import "AtomMp4a.h"

@implementation AtomMp4a

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mp4a");
}

+(NSString *)atomName
{
    return (@"MP4 Audio Sample Entry");
}

-(NSUInteger) jump
{
    UInt16 version = [self getUInt16ValueAtOffset:16];
    if (version > 0) {
        return 44;
    }

    return 28;
}

@end
