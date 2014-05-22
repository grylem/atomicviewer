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

- (NSString *)atomName
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
        const tkhd_ver0 *tkhd_addr = [[self data] bytes];
        _trakNumber = CFSwapInt32BigToHost(tkhd_addr->track_ID);
//        NSRange track_IDRange = NSMakeRange(offsetof(struct tkhd_ver0, track_ID), member_size(tkhd_ver0, track_ID));
//        [self.data getBytes:&_trakNumber range:track_IDRange];
//        _trakNumber = CFSwapInt32BigToHost((uint32_t)_trakNumber);
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
    uint16_t hours;
    uint16_t minutes;
    double seconds;
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
    uint16_t width_hi;
    uint16_t width_lo;
    uint16_t height_hi;
    uint16_t height_lo;

    const tkhd_ver0 *tkhd = [[self data] bytes];

    NSDate *creationDate = [self getUInt32TimeValueAtOffset:offsetof(struct tkhd_ver0, creation_time)];
    NSDate *modificationDate = [self getUInt32TimeValueAtOffset:offsetof(struct tkhd_ver0, modification_time)];
    uint32_t track_ID = CFSwapInt32BigToHost(tkhd->track_ID);
    uint64_t duration = [self getUInt32DurationValueAtOffset: offsetof(struct tkhd_ver0, duration)
                                     usingTimescale: [self timescale]
                                              hours: &hours
                                            minutes: &minutes
                                            seconds: &seconds];
    uint16_t layer = CFSwapInt16BigToHost(tkhd->layer);
    uint16_t alternate_group = CFSwapInt32BigToHost(tkhd->alternate_group);
    [self get88ValueAtOffset:offsetof(struct tkhd_ver0, volume) hi:&volume_hi lo:&volume_lo];
    [self get1616ValueAtOffset: offsetof(struct tkhd_ver0, matrix[0]) hi:&matrixa_hi  lo:&matrixa_lo];
    [self get1616ValueAtOffset: offsetof(struct tkhd_ver0, matrix[1]) hi:&matrixb_hi  lo:&matrixb_lo];
    [self get230ValueAtOffset:  offsetof(struct tkhd_ver0, matrix[2]) hi:&matrixu_hi  lo:&matrixu_lo];
    [self get1616ValueAtOffset: offsetof(struct tkhd_ver0, matrix[3]) hi:&matrixc_hi  lo:&matrixc_lo];
    [self get1616ValueAtOffset: offsetof(struct tkhd_ver0, matrix[4]) hi:&matrixd_hi  lo:&matrixd_lo];
    [self get230ValueAtOffset:  offsetof(struct tkhd_ver0, matrix[5]) hi:&matrixv_hi  lo:&matrixv_lo];
    [self get1616ValueAtOffset: offsetof(struct tkhd_ver0, matrix[6]) hi:&matrixtx_hi lo:&matrixtx_lo];
    [self get1616ValueAtOffset: offsetof(struct tkhd_ver0, matrix[7]) hi:&matrixty_hi lo:&matrixty_lo];
    [self get230ValueAtOffset:  offsetof(struct tkhd_ver0, matrix[8]) hi:&matrixw_hi  lo:&matrixw_lo];
    [self get1616ValueAtOffset:offsetof(struct tkhd_ver0, width) hi:&width_hi lo:&width_lo];
    [self get1616ValueAtOffset:offsetof(struct tkhd_ver0, height) hi:&height_hi lo:&height_lo];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      Creation date: <b>%@</b><br>\
                      Modification date: <b>%@</b><br>\
                      Track ID: <b>%u</b><br>\
                      Duration: <b>%llu (%02u:%02u:%09.6f)</b><br>\
                      Layer: <b>%u</b><br>\
                      Alternate Group: <b>%u</b><br>\
                      Volume: <b>%u.%u</b><br>\
                      Transformation Matrix:\
                      <TABLE style=\"font-size:1.0em;\">\
                      <TR><TD><b>%u.%u</b></TD><TD><b>%u.%u</b></TD><TD><b>%u.%u</b></TD></TR>\
                      <TR><TD><b>%u.%u</b></TD><TD><b>%u.%u</b></TD><TD><b>%u.%u</b></TD></TR>\
                      <TR><TD><b>%u.%u</b></TD><TD><b>%u.%u</b></TD><TD><b>%u.%u</b></TD></TR>\
                      </TABLE><br>\
                      Width: <b>%u.%u</b><br>\
                      Height: <b>%u.%u</b>\
                      </p></span></body>",
                      creationDate,
                      modificationDate,
                      track_ID,
                      duration, hours, minutes, seconds,
                      layer,
                      alternate_group,
                      volume_hi, volume_lo,
                      matrixa_hi, matrixa_lo, matrixb_hi, matrixb_lo, matrixu_hi, matrixu_lo,
                      matrixc_hi, matrixc_lo, matrixd_hi, matrixd_lo, matrixv_hi, matrixv_lo,
                      matrixtx_hi, matrixtx_lo, matrixty_hi, matrixty_lo, matrixw_hi, matrixw_lo,
                      width_hi, width_lo,
                      height_hi, height_lo];

    return html;
}

@end
