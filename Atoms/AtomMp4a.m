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

#pragma pack(push,1)
typedef struct mp4a
{
    uint8_t reserved[6];
    uint16_t data_reference_index;
    uint16_t version;
    uint16_t revision_level;
    uint32_t vendor;
    uint16_t number_of_channels;
    uint16_t sample_size;
    uint16_t compression_ID;
    uint16_t packet_size;
    uint32_t sample_rate; // Version 0 ends after this field (28 bytes)
    uint32_t samples_per_packet;
    uint32_t bytes_per_packet;
    uint32_t bytes_per_frame;
    uint32_t bytes_per_sample;
}mp4a;
#pragma pack(pop)

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mp4a");
}

- (NSString *)atomName
{
    return (@"MP4 Audio Sample Description");
}

-(NSUInteger) jump
{
    const mp4a* mp4a = [[self data] bytes];

    uint16_t version = CFSwapInt16BigToHost(mp4a->version);
    if (version == 1) {
        return sizeof(struct mp4a);
    }
    return offsetof(struct mp4a, samples_per_packet);
}

@end
