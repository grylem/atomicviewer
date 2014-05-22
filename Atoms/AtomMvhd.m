//
//  AtomMvhd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMvhd.h"

#define member_size(type, member) sizeof(((type *)0)->member)

#pragma pack(push,1)
typedef struct mvhd_ver0
{
    uint32_t creation_time;
    uint32_t modification_time;
    uint32_t timescale;
    uint32_t duration;
    uint32_t rate;
    uint16_t volume;
    uint16_t reserved;
    uint32_t reserved1[2];
    uint32_t matrix[9];
    uint32_t predefined[6];
    uint32_t next_track_ID;
} mvhd_ver0;

typedef struct mvhd_ver1
{
    uint64_t creation_time;
    uint64_t modification_time;
    uint32_t timescale;
    uint64_t duration;
    uint32_t rate;
    uint16_t volume;
    uint16_t reserved;
    uint32_t reserved1[2];
    uint32_t matrix[9];
    uint32_t predefined[6];
    uint32_t next_track_ID;
} mvhd_ver1;
#pragma pack(pop)

@implementation AtomMvhd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mvhd");
}

- (NSString *)atomName
{
    return (@"Movie Header");
}

-(BOOL)isFullBox
{
    return YES;
}

- (uint32_t)timescale
{
    const mvhd_ver0 *mvhd_addr = [[self data] bytes];
    return CFSwapInt32BigToHost(mvhd_addr->timescale);
}

- (NSString *)html
{
    uint16_t hours;
    uint16_t minutes;
    double seconds;
    uint16_t rate_hi;
    uint16_t rate_lo;
    uint8_t volume_hi;
    uint8_t volume_lo;
    uint16_t matrixa_hi;
    uint16_t matrixa_lo;
    uint16_t matrixb_hi;
    uint16_t matrixb_lo;
    uint8_t matrixu_hi;
    uint32_t matrixu_lo;
    uint16_t matrixc_hi;
    uint16_t matrixc_lo;
    uint16_t matrixd_hi;
    uint16_t matrixd_lo;
    uint8_t matrixv_hi;
    uint32_t matrixv_lo;
    uint16_t matrixtx_hi;
    uint16_t matrixtx_lo;
    uint16_t matrixty_hi;
    uint16_t matrixty_lo;
    uint8_t matrixw_hi;
    uint32_t matrixw_lo;

    const mvhd_ver0 *mvhd = [[self data] bytes];

    NSDate *creationDate = [self getUInt32TimeValueAtOffset: offsetof(struct mvhd_ver0, creation_time)];
    NSDate *modificationDate = [self getUInt32TimeValueAtOffset: offsetof(struct mvhd_ver0, modification_time)];
    uint32_t timescale = [self timescale];
    uint64_t duration = [self getUInt32DurationValueAtOffset: offsetof(struct mvhd_ver0, duration)
                                     usingTimescale: [self timescale]
                                              hours: &hours
                                            minutes: &minutes
                                            seconds: &seconds];
    [self get1616ValueAtOffset: offsetof(struct mvhd_ver0, rate) hi: &rate_hi lo: &rate_lo];
    [self get88ValueAtOffset:offsetof(struct mvhd_ver0, volume) hi:&volume_hi lo:&volume_lo];
    [self get1616ValueAtOffset:offsetof(struct mvhd_ver0, matrix[0]) hi:&matrixa_hi lo:&matrixa_lo];
    [self get1616ValueAtOffset:offsetof(struct mvhd_ver0, matrix[1]) hi:&matrixb_hi lo:&matrixb_lo];
    [self get230ValueAtOffset:offsetof(struct mvhd_ver0, matrix[2]) hi:&matrixu_hi lo:&matrixu_lo];
    [self get1616ValueAtOffset:offsetof(struct mvhd_ver0, matrix[3]) hi:&matrixc_hi lo:&matrixc_lo];
    [self get1616ValueAtOffset:offsetof(struct mvhd_ver0, matrix[4]) hi:&matrixd_hi lo:&matrixd_lo];
    [self get230ValueAtOffset:offsetof(struct mvhd_ver0, matrix[5]) hi:&matrixv_hi lo:&matrixv_lo];
    [self get1616ValueAtOffset:offsetof(struct mvhd_ver0, matrix[6]) hi:&matrixtx_hi lo:&matrixtx_lo];
    [self get1616ValueAtOffset:offsetof(struct mvhd_ver0, matrix[7]) hi:&matrixty_hi lo:&matrixty_lo];
    [self get230ValueAtOffset:offsetof(struct mvhd_ver0, matrix[8]) hi:&matrixw_hi lo:&matrixw_lo];
    uint32_t next_track_ID = CFSwapInt32BigToHost(mvhd->next_track_ID);

    NSString *html = [NSString stringWithFormat:@"<body>The movie header, describing characteristics of the entire movie, such as time scale and duration.<span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p><br>\
                      Creation date: <b>%@</b><br>\
                      Modification date: <b>%@</b><br>\
                      Timescale: <b>%u</b><br>\
                      Duration: <b>%llu (%02u:%02u:%09.6f)</b><br>\
                      Rate: <b>%u.%u</b><br>\
                      Volume: <b>%u.%u</b><br>\
                      Transformation Matrix:\
                      <TABLE style=\"font-size:1.0em;\">\
                      <TR><TD><b>%u.%u</b></TD><TD><b>%u.%u</b></TD><TD><b>%u.%u</b></TD></TR>\
                      <TR><TD><b>%u.%u</b></TD><TD><b>%u.%u</b></TD><TD><b>%u.%u</b></TD></TR>\
                      <TR><TD><b>%u.%u</b></TD><TD><b>%u.%u</b></TD><TD><b>%u.%u</b></TD></TR>\
                      </TABLE><br>\
                      Next Track ID: <b>%u<b>\
                      </p></span></body>",
                      creationDate,
                      modificationDate,
                      timescale,
                      duration, hours, minutes, seconds,
                      rate_hi, rate_lo,
                      volume_hi, volume_lo,
                      matrixa_hi, matrixa_lo, matrixb_hi, matrixb_lo, matrixu_hi, matrixu_lo,
                      matrixc_hi, matrixc_lo, matrixd_hi, matrixd_lo, matrixv_hi, matrixv_lo,
                      matrixtx_hi, matrixtx_lo, matrixty_hi, matrixty_lo, matrixw_hi, matrixw_lo,
                      next_track_ID];
    return html;
}
@end
