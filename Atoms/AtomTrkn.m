//
//  AtomTrkn.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTrkn.h"

// These are offsets within my child 'data' atom
typedef enum : off_t {
    size = 0,
    type = 4,
    datatype = 8,
    locale = 12,
    reserved1 = 16,
    tracknumber = 18,
    totaltracks = 20
} offsets;

@implementation AtomTrkn

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"trkn");
}

+(NSString *)atomName
{
    return (@"Track Number");
}

-(UInt16)trackNumber
{
    if (!_trackNumber) {
        _trackNumber = [self getUInt16ValueAtOffset:tracknumber];
    }
    return _trackNumber;
}

-(UInt16)totalTracks
{
    if (!_totalTracks) {
        _totalTracks = [self getUInt16ValueAtOffset:totaltracks];
    }
    return _totalTracks;
}

- (NSAttributedString *)decodedExplanation
{
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Track %hu of %hu", self.trackNumber, self.totalTracks]];
}

@end
