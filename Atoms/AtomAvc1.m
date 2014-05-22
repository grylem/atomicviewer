//
//  AtomAvc1.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomAvc1.h"

@implementation AtomAvc1

#pragma pack(push,1)
typedef struct avc1
{
    uint8_t reserved[6];
    uint16_t data_reference_index;
    uint16_t pre_defined;
    uint16_t reserved1;
    uint32_t pre_defined1[3];
    uint16_t width;
    uint16_t height;
    uint32_t horizresolution;
    uint32_t vertresolution;
    uint32_t reserved2;
    uint16_t frame_count;
    char compressorname[32];
    uint16_t depth;
    uint16_t pre_defined2;
}avc1;
#pragma pack(pop)

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"avc1");
}

- (NSString *)atomName
{
    return (@"AVC Visual Sample Description");
}

-(NSUInteger) jump
{
    return sizeof(avc1);
}

- (NSString *)html
{
    const avc1 *avc1 = [[self data] bytes];

    uint16_t horizresolution_hi;
    uint16_t horizresolution_lo;
    uint16_t vertresolution_hi;
    uint16_t vertresolution_lo;
    NSString *compressorname;

    [self get1616ValueAtOffset:offsetof(struct avc1, horizresolution) hi:&horizresolution_hi lo:&horizresolution_lo];
    [self get1616ValueAtOffset:offsetof(struct avc1, vertresolution) hi:&vertresolution_hi lo:&vertresolution_lo];

    uint8_t string_length = *(avc1->compressorname);
    compressorname = [[NSString alloc] initWithBytes:(avc1->compressorname + 1)
                                              length:string_length
                                            encoding:NSUTF8StringEncoding];

    NSString *html = [NSString stringWithFormat:@"<body>This is the Visual Sample Description for AVC samples. Defined in ISO/IEC 14496-12 &sect 8.16.2 and 14496-15 &sect 5.3.4.1.<br><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p><br>\
                      Data Reference Index: <b>%u</b><br>\
                      Width: <b>%u</b><br>\
                      Height: <b>%u</b><br>\
                      Horizontal Resolution: <b>%u.%u</b><br>\
                      Vertical Resolution: <b>%u.%u</b><br>\
                      Frame Count: <b>%u</b><br>\
                      Compressor Name: <b>%@</b><br>\
                      Depth: <b>%u</b><br>\
                      </p></span></body>",
                      CFSwapInt16BigToHost(avc1->data_reference_index),
                      CFSwapInt16BigToHost(avc1->width),
                      CFSwapInt16BigToHost(avc1->height),
                      horizresolution_hi,
                      horizresolution_lo,
                      vertresolution_hi,
                      vertresolution_lo,
                      CFSwapInt16BigToHost(avc1->frame_count),
                      compressorname,
                      CFSwapInt16BigToHost(avc1->depth)];

    return html;
}

@end
