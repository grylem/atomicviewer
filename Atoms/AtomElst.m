//
//  AtomElst.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomElst.h"
#import "AtomMvhd.h"

@implementation AtomElst

#pragma pack(push,1)
typedef struct elst_ver0
{
    uint32_t entry_count;
    struct {
        uint32_t segment_duration;
        int32_t media_time;
        uint32_t media_rate;
    } entry[];
} elst_ver0;
typedef struct elst_ver1
{
    uint32_t entry_count;
    struct {
        uint64_t segment_duration;
        int64_t media_time;
        uint32_t media_rate;
    } entry[];

} elst_ver1;
#pragma pack(pop)

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"elst");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Edit List",
                                      @"atomName",
                                      @"Atom elst name");
}

-(BOOL)isFullBox
{
    return YES;
}

- (double)timescale
{
    AtomMvhd *atom = (AtomMvhd *)[self findAtomAtPath:@"moov.mvhd"];
    return [atom timescale];
}

- (NSString *)html
{
    const elst_ver0 *elst = [[self data] bytes];

    NSString *html = @"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
    <TABLE style=\"font-size:1.0em;\">\
    <TR> <TH>Segment Duration</TH><TH>Media Time</TH><TH>Media Rate</TH>";

    uint32_t count = CFSwapInt32BigToHost(elst->entry_count);

    for (int i=0; i<count; i++) {
        uint16_t hours;
        uint16_t minutes;
        double seconds;
        uint32_t duration = [self getUInt32DurationValueAtOffset: offsetof(struct elst_ver0, entry[i].segment_duration)
                                                  usingTimescale: [self timescale]
                                                           hours: &hours
                                                         minutes: &minutes
                                                         seconds: &seconds];
        int32_t mtime = CFSwapInt32BigToHost(elst->entry[i].media_time);
        uint32_t rate = CFSwapInt32BigToHost(elst->entry[i].media_rate);
        int16_t rate_hi = rate >> 16;
        int16_t rate_lo = rate & 0xffff;

        NSNumberFormatter *hoursMinutesFormatter = [[NSNumberFormatter alloc] init];
        [hoursMinutesFormatter setPositiveFormat: @"00"];
        NSNumberFormatter *secondsFormatter = [[NSNumberFormatter alloc] init];
        [secondsFormatter setPositiveFormat: @"00.000000"];

        html = [html stringByAppendingFormat:@"<TR><TD>%@ (%@:%@:%@)</TD><TD>%@</TD><TD>%@.%@</TD></TR>",
                @(duration),
                [hoursMinutesFormatter stringFromNumber: @(hours)],
                [hoursMinutesFormatter stringFromNumber: @(minutes)],
                [secondsFormatter stringFromNumber: @(seconds)],
                @(mtime),
                @(rate_hi), @(rate_lo)];
    }
    html = [html stringByAppendingString:@"</TABLE><br></p></span></body>"];
    return html;
}

@end
