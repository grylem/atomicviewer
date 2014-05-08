//
//  AtomTkhd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTkhd.h"
#import "AtomMvhd.h"

#define member_size(type, member) sizeof(((type *)0)->member)

#pragma pack(push,1)
typedef struct tkhd_ver0
{
    uint32_t creation_time;
    uint32_t modification_time;
    uint32_t track_ID;
    uint32_t reserved;
    uint32_t duration;
    uint32_t reserved1[2];
    uint16_t layer;
    uint16_t alternate_group;
    uint16_t volume;
    uint16_t reserved2;
    uint32_t matrix[9];
    uint32_t width;
    uint32_t height;
} tkhd_ver0;

typedef struct tkhd_ver1
{
    uint64_t creation_time;
    uint64_t modification_time;
    uint32_t track_ID;
    uint32_t reserved;
    uint64_t duration;
    uint32_t reserved1[2];
    uint16_t layer;
    uint16_t alternate_group;
    uint16_t volume;
    uint16_t reserved2;
    uint32_t matrix[9];
    uint32_t width;
    uint32_t height;
} tkhd_ver1;
#pragma pack(pop)

typedef enum : off_t {
    trakNumberOffset = 20
} offsets;

@implementation AtomTkhd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"tkhd");
}

+(NSString *)atomName
{
    return (@"Track Header");
}

-(BOOL)isFullBox
{
    return YES;
}

-(instancetype) initWithLength: (size_t)atomLength
                    dataOffset: (off_t)offset
                    isExtended: (BOOL)isExtendedLength
               usingFileHandle: (NSFileHandle *)fileHandle
                    withParent: (Atom *)parent
{
    self = [super initWithLength: atomLength
                      dataOffset: offset
                      isExtended: isExtendedLength
                 usingFileHandle: fileHandle
                      withParent: parent];
    if (self) {
        _trakNumber = NSUIntegerMax; // init trakNumber to a sentinel value so we know if it's been set yet or not
    }
    return self;
}

-(NSUInteger)trakNumber
{
    if (_trakNumber == NSUIntegerMax) {
        NSRange track_IDRange = NSMakeRange(offsetof(struct tkhd_ver0, track_ID), member_size(tkhd_ver0, track_ID));
        [self.data getBytes:&_trakNumber range:track_IDRange];
        _trakNumber = CFSwapInt32BigToHost((uint32_t)_trakNumber);
    }
    return _trakNumber;
}

- (double)timescale
{
    AtomMvhd *atom = (AtomMvhd *)[self findAtomAtPath:@"moov.mvhd"];
    return [atom timescale];
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
    uint32_t track_ID;
    uint32_t duration;
    uint16_t layer;
    uint16_t alternate_group;
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
    uint32_t width;
    uint32_t height;

    NSRange creationTimeRange = NSMakeRange(offsetof(struct tkhd_ver0, creation_time), member_size(tkhd_ver0, creation_time));
    [self.data getBytes:&ver0_creationTime range:creationTimeRange];

    creationTime = CFSwapInt32BigToHost(ver0_creationTime);
    creationDate = [NSDate dateWithTimeInterval:creationTime sinceDate:referenceDate];

    NSRange modificationTimeRange = NSMakeRange(offsetof(struct tkhd_ver0, modification_time), member_size(tkhd_ver0, modification_time));
    [self.data getBytes:&ver0_modificationTime range:modificationTimeRange];

    modificationTime = CFSwapInt32BigToHost(ver0_modificationTime);
    modificationDate = [NSDate dateWithTimeInterval:modificationTime sinceDate:referenceDate];

    NSRange track_IDRange = NSMakeRange(offsetof(struct tkhd_ver0, track_ID), member_size(tkhd_ver0, track_ID));
    [self.data getBytes:&track_ID range:track_IDRange];
    track_ID = CFSwapInt32BigToHost(track_ID);

    NSRange durationRange = NSMakeRange(offsetof(struct tkhd_ver0, duration), member_size(tkhd_ver0, duration));
    [self.data getBytes:&duration range:durationRange];
    duration = CFSwapInt32BigToHost(duration);
    double total_seconds = (double)duration / [self timescale];
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

    NSRange layerRange = NSMakeRange(offsetof(struct tkhd_ver0, layer), member_size(tkhd_ver0, layer));
    [self.data getBytes:&layer range:layerRange];
    layer = CFSwapInt16BigToHost(layer);

    NSRange alternate_groupRange = NSMakeRange(offsetof(struct tkhd_ver0, alternate_group), member_size(tkhd_ver0, alternate_group));
    [self.data getBytes:&alternate_group range:alternate_groupRange];
    alternate_group = CFSwapInt32BigToHost(alternate_group);

    NSRange volumeRange = NSMakeRange(offsetof(struct tkhd_ver0, volume), member_size(tkhd_ver0, volume));
    [self.data getBytes:&volume range:volumeRange];
    volume = CFSwapInt16BigToHost(volume);
    uint8_t volume_hi = volume >> 8;
    uint8_t volume_lo = volume & 0xff;

    NSRange matrixaRange = NSMakeRange(offsetof(struct tkhd_ver0, matrix[0]), member_size(tkhd_ver0, matrix[0]));
    [self.data getBytes:&matrixa range:matrixaRange];
    matrixa = CFSwapInt32BigToHost(matrixa);
    uint16_t matrixa_hi = matrixa >> 16;
    uint16_t matrixa_lo = matrixa & 0xffff;

    NSRange matrixbRange = NSMakeRange(offsetof(struct tkhd_ver0, matrix[1]), member_size(tkhd_ver0, matrix[1]));
    [self.data getBytes:&matrixb range:matrixbRange];
    matrixb = CFSwapInt32BigToHost(matrixb);
    uint16_t matrixb_hi = matrixb >> 16;
    uint16_t matrixb_lo = matrixb & 0xffff;

    NSRange matrixuRange = NSMakeRange(offsetof(struct tkhd_ver0, matrix[2]), member_size(tkhd_ver0, matrix[2]));
    [self.data getBytes:&matrixu range:matrixuRange];
    matrixu = CFSwapInt32BigToHost(matrixu);
    uint8_t matrixu_hi = matrixu >> 30;
    uint32_t matrixu_lo = matrixu & 0x3fffffff;

    NSRange matrixcRange = NSMakeRange(offsetof(struct tkhd_ver0, matrix[3]), member_size(tkhd_ver0, matrix[3]));
    [self.data getBytes:&matrixc range:matrixcRange];
    matrixc = CFSwapInt32BigToHost(matrixc);
    uint16_t matrixc_hi = matrixc >> 16;
    uint16_t matrixc_lo = matrixc & 0xffff;

    NSRange matrixdRange = NSMakeRange(offsetof(struct tkhd_ver0, matrix[4]), member_size(tkhd_ver0, matrix[4]));
    [self.data getBytes:&matrixd range:matrixdRange];
    matrixd = CFSwapInt32BigToHost(matrixd);
    uint16_t matrixd_hi = matrixd >> 16;
    uint16_t matrixd_lo = matrixd & 0xffff;

    NSRange matrixvRange = NSMakeRange(offsetof(struct tkhd_ver0, matrix[5]), member_size(tkhd_ver0, matrix[5]));
    [self.data getBytes:&matrixv range:matrixvRange];
    matrixv = CFSwapInt32BigToHost(matrixv);
    uint8_t matrixv_hi = matrixv >> 30;
    uint32_t matrixv_lo = matrixv & 0x3fffffff;

    NSRange matrixtxRange = NSMakeRange(offsetof(struct tkhd_ver0, matrix[6]), member_size(tkhd_ver0, matrix[6]));
    [self.data getBytes:&matrixtx range:matrixtxRange];
    matrixtx = CFSwapInt32BigToHost(matrixtx);
    uint16_t matrixtx_hi = matrixtx >> 16;
    uint16_t matrixtx_lo = matrixtx & 0xffff;

    NSRange matrixtyRange = NSMakeRange(offsetof(struct tkhd_ver0, matrix[7]), member_size(tkhd_ver0, matrix[7]));
    [self.data getBytes:&matrixty range:matrixtyRange];
    matrixty = CFSwapInt32BigToHost(matrixty);
    uint16_t matrixty_hi = matrixty >> 16;
    uint16_t matrixty_lo = matrixty & 0xffff;

    NSRange matrixwRange = NSMakeRange(offsetof(struct tkhd_ver0, matrix[8]), member_size(tkhd_ver0, matrix[8]));
    [self.data getBytes:&matrixw range:matrixwRange];
    matrixw = CFSwapInt32BigToHost(matrixw);
    uint8_t matrixw_hi = matrixw >> 30;
    uint32_t matrixw_lo = matrixw & 0x3fffffff;

    NSRange widthRange = NSMakeRange(offsetof(struct tkhd_ver0, width), member_size(tkhd_ver0, width));
    [self.data getBytes:&width range:widthRange];
    width = CFSwapInt32BigToHost(width);
    uint16_t width_hi = width >> 16;
    uint16_t width_lo = width & 0xffff;

    NSRange heightRange = NSMakeRange(offsetof(struct tkhd_ver0, height), member_size(tkhd_ver0, height));
    [self.data getBytes:&height range:heightRange];
    height = CFSwapInt32BigToHost(height);
    uint16_t height_hi = height >> 16;
    uint16_t height_lo = height & 0xffff;

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>Creation date: %@<br>Modification date: %@<br>Track ID: %u<br>Duration: %u (%02u:%02u:%09.6f)<br>Layer: %u<br>Alternate Group: %u<br>Volume: %u.%u<br>Matrix:<TABLE><TR><TD>%u.%u</TD><TD>%u.%u</TD><TD>%u.%u</TD></TR><TR><TD>%u.%u</TD><TD>%u.%u</TD><TD>%u.%u</TD></TR><TR><TD>%u.%u</TD><TD>%u.%u</TD><TD>%u.%u</TD></TR></TABLE><br>Width: %u.%u<br>Height: %u.%u</p></span></body>", creationDate, modificationDate, track_ID, duration, hours, minutes, seconds, layer, alternate_group, volume_hi, volume_lo, matrixa_hi, matrixa_lo, matrixb_hi, matrixb_lo, matrixu_hi, matrixu_lo, matrixc_hi, matrixc_lo, matrixd_hi, matrixd_lo, matrixv_hi, matrixv_lo, matrixtx_hi, matrixtx_lo, matrixty_hi, matrixty_lo, matrixw_hi, matrixw_lo, width_hi, width_lo, height_hi, height_lo];

    return html;
}

@end
