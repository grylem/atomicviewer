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

+(NSString *)atomName
{
    return (@"Movie Header");
}

-(BOOL)isFullBox
{
    return YES;
}

- (uint32_t)timescale
{
    uint32_t timescale;

    NSRange timescaleRange = NSMakeRange(offsetof(struct mvhd_ver0, timescale), member_size(mvhd_ver0, timescale));
    [self.data getBytes:&timescale range:timescaleRange];
    timescale = CFSwapInt32BigToHost(timescale);
    return timescale;
}

- (NSString *)html
{
    NSDate *referenceDate = [NSDate dateWithString:@"1904-01-01 00:00:00 +0000"];
    NSTimeInterval creationTime;
    NSTimeInterval modificationTime;
    NSDate *creationDate;
    NSDate *modificationDate;
    uint32_t ver0_creationTime;
    uint32_t ver0_modificationTime;
    uint32_t timescale;
    uint32_t duration;
    uint32_t rate;
    uint16_t volume;
    uint32_t matrixa;
    uint32_t matrixb;
    uint32_t matrixu;
    uint32_t matrixc;
    uint32_t matrixd;
    uint32_t matrixv;
    uint32_t matrixtx;
    uint32_t matrixty;
    uint32_t matrixw;
    uint32_t next_track_ID;

    NSRange creationTimeRange = NSMakeRange(offsetof(struct mvhd_ver0, creation_time), member_size(mvhd_ver0, creation_time));
    [self.data getBytes:&ver0_creationTime range:creationTimeRange];

    creationTime = CFSwapInt32BigToHost(ver0_creationTime);
    creationDate = [NSDate dateWithTimeInterval:creationTime sinceDate:referenceDate];

    NSRange modificationTimeRange = NSMakeRange(offsetof(struct mvhd_ver0, modification_time), member_size(mvhd_ver0, modification_time));
    [self.data getBytes:&ver0_modificationTime range:modificationTimeRange];

    modificationTime = CFSwapInt32BigToHost(ver0_modificationTime);
    modificationDate = [NSDate dateWithTimeInterval:modificationTime sinceDate:referenceDate];

    timescale = [self timescale];

    NSRange durationRange = NSMakeRange(offsetof(struct mvhd_ver0, duration), member_size(mvhd_ver0, duration));
    [self.data getBytes:&duration range:durationRange];
    duration = CFSwapInt32BigToHost(duration);
    double total_seconds = (double)duration / (double)timescale;
    uint16_t hours = 0;
    uint16_t minutes = 0;
    double seconds = total_seconds;
    if (seconds >= 60) {
        minutes = seconds / 60;
        seconds = seconds - (minutes * 60);
    }
    if (minutes >= 60) {
        hours = total_seconds / (60 * 60);
        minutes = minutes - (hours * 60);
    }

    NSRange rateRange = NSMakeRange(offsetof(struct mvhd_ver0, rate), member_size(mvhd_ver0, rate));
    [self.data getBytes:&rate range:rateRange];
    rate = CFSwapInt32BigToHost(rate);
    uint16_t rate_hi = rate >> 16;
    uint16_t rate_lo = rate & 0xffff;

    NSRange volumeRange = NSMakeRange(offsetof(struct mvhd_ver0, volume), member_size(mvhd_ver0, volume));
    [self.data getBytes:&volume range:volumeRange];
    volume = CFSwapInt16BigToHost(volume);
    uint8_t volume_hi = volume >> 8;
    uint8_t volume_lo = volume & 0xff;

    NSRange matrixaRange = NSMakeRange(offsetof(struct mvhd_ver0, matrix[0]), member_size(mvhd_ver0, matrix[0]));
    [self.data getBytes:&matrixa range:matrixaRange];
    matrixa = CFSwapInt32BigToHost(matrixa);
    uint16_t matrixa_hi = matrixa >> 16;
    uint16_t matrixa_lo = matrixa & 0xffff;

    NSRange matrixbRange = NSMakeRange(offsetof(struct mvhd_ver0, matrix[1]), member_size(mvhd_ver0, matrix[1]));
    [self.data getBytes:&matrixb range:matrixbRange];
    matrixb = CFSwapInt32BigToHost(matrixb);
    uint16_t matrixb_hi = matrixb >> 16;
    uint16_t matrixb_lo = matrixb & 0xffff;

    NSRange matrixuRange = NSMakeRange(offsetof(struct mvhd_ver0, matrix[2]), member_size(mvhd_ver0, matrix[2]));
    [self.data getBytes:&matrixu range:matrixuRange];
    matrixu = CFSwapInt32BigToHost(matrixu);
    uint8_t matrixu_hi = matrixu >> 30;
    uint32_t matrixu_lo = matrixu & 0x3fffffff;

    NSRange matrixcRange = NSMakeRange(offsetof(struct mvhd_ver0, matrix[3]), member_size(mvhd_ver0, matrix[3]));
    [self.data getBytes:&matrixc range:matrixcRange];
    matrixc = CFSwapInt32BigToHost(matrixc);
    uint16_t matrixc_hi = matrixc >> 16;
    uint16_t matrixc_lo = matrixc & 0xffff;

    NSRange matrixdRange = NSMakeRange(offsetof(struct mvhd_ver0, matrix[4]), member_size(mvhd_ver0, matrix[4]));
    [self.data getBytes:&matrixd range:matrixdRange];
    matrixd = CFSwapInt32BigToHost(matrixd);
    uint16_t matrixd_hi = matrixd >> 16;
    uint16_t matrixd_lo = matrixd & 0xffff;

    NSRange matrixvRange = NSMakeRange(offsetof(struct mvhd_ver0, matrix[5]), member_size(mvhd_ver0, matrix[5]));
    [self.data getBytes:&matrixv range:matrixvRange];
    matrixv = CFSwapInt32BigToHost(matrixv);
    uint8_t matrixv_hi = matrixv >> 30;
    uint32_t matrixv_lo = matrixv & 0x3fffffff;

    NSRange matrixtxRange = NSMakeRange(offsetof(struct mvhd_ver0, matrix[6]), member_size(mvhd_ver0, matrix[6]));
    [self.data getBytes:&matrixtx range:matrixtxRange];
    matrixtx = CFSwapInt32BigToHost(matrixtx);
    uint16_t matrixtx_hi = matrixtx >> 16;
    uint16_t matrixtx_lo = matrixtx & 0xffff;

    NSRange matrixtyRange = NSMakeRange(offsetof(struct mvhd_ver0, matrix[7]), member_size(mvhd_ver0, matrix[7]));
    [self.data getBytes:&matrixty range:matrixtyRange];
    matrixty = CFSwapInt32BigToHost(matrixty);
    uint16_t matrixty_hi = matrixty >> 16;
    uint16_t matrixty_lo = matrixty & 0xffff;

    NSRange matrixwRange = NSMakeRange(offsetof(struct mvhd_ver0, matrix[8]), member_size(mvhd_ver0, matrix[8]));
    [self.data getBytes:&matrixw range:matrixwRange];
    matrixw = CFSwapInt32BigToHost(matrixw);
    uint8_t matrixw_hi = matrixw >> 30;
    uint32_t matrixw_lo = matrixw & 0x3fffffff;

    NSRange next_track_IDRange = NSMakeRange(offsetof(struct mvhd_ver0, next_track_ID), member_size(mvhd_ver0, next_track_ID));
    [self.data getBytes:&next_track_ID range:next_track_IDRange];
    next_track_ID = CFSwapInt32BigToHost(next_track_ID);

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>Creation date: %@<br>Modification date: %@<br>Timescale: %u<br>Duration: %u (%02u:%02u:%09.6f)<br>Rate: %u.%u<br>Volume: %u.%u<br>Matrix:<br>%u.%u, %u.%u, %u.%u<br>%u.%u, %u.%u, %u.%u<br>%u.%u, %u.%u, %u.%u<br>Next Track ID: %u</p></span></body>", creationDate, modificationDate, timescale, duration, hours, minutes, seconds, rate_hi, rate_lo, volume_hi, volume_lo, matrixa_hi, matrixa_lo, matrixb_hi, matrixb_lo, matrixu_hi, matrixu_lo, matrixc_hi, matrixc_lo, matrixd_hi, matrixd_lo, matrixv_hi, matrixv_lo, matrixtx_hi, matrixtx_lo, matrixty_hi, matrixty_lo, matrixw_hi, matrixw_lo, next_track_ID];

    return html;
}
@end
