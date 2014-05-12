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
    tracknumber = 18, // -12
    totaltracks = 20  // -12
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

- (NSString *)atomName
{
    return (@"Track Number");
}

-(UInt16)trackNumber
{
    if (!_trackNumber) {
        _trackNumber = [self getUInt16ValueAtOffset:6];
    }
    return _trackNumber;
}

-(UInt16)totalTracks
{
    if (!_totalTracks) {
        _totalTracks = [self getUInt16ValueAtOffset:8];
    }
    return _totalTracks;
}

- (NSString *)html
{
    return [NSString stringWithFormat:@"Track %hu of %hu", self.trackNumber, self.totalTracks];
}

@end
