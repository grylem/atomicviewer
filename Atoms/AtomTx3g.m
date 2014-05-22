//
//  AtomTx3g.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/23/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTx3g.h"

#pragma pack(push,1)
typedef struct tx3g
{
    uint8_t reserved[6];
    uint16_t data_reference_index;
    uint32_t display_flags;
    uint8_t reserved1;
    uint8_t reserved2;
    uint32_t reserved3;
    struct {
        uint16_t top;
        uint16_t left;
        uint16_t bottom;
        uint16_t right;
    } default_text_box;
    uint32_t reserved4;
    uint16_t font_identifier;
    uint8_t font_face;
    uint8_t font_size;
    uint32_t foreground_color;
}tx3g;
#pragma pack(pop)

@implementation AtomTx3g

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return @"tx3g";
}

- (NSString *)atomName
{
    return @"Subtitle Sample Description";
}

-(NSUInteger) jump
{
    return sizeof(struct tx3g);
}

- (NSString *)html
{
    const tx3g *tx3g = [[self data] bytes];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      Data Reference Index: <b>%u</b><br>\
                      All Samples are Forced: <b>%@</b><br>\
                      Some Samples are Forced: <b>%@</b><br>\
                      Vertical Placement: <b>%@</b><br>\
                      Text Box Top: <b>%u</b><br>\
                      Text Box Left: <b>%u</b><br>\
                      Text Box Bottom: <b>%u</b><br>\
                      Text Box Right: <b>%u</b><br>\
                      Font Identifier: <b>%u</b><br>\
                      Font Face Bold: <b>%@</b><br>\
                      Font Face Italic: <b>%@</b><br>\
                      Font Face Underline: <b>%@</b><br>\
                      Font Size: <b>%u</b><br>\
                      Foreground Color: <b>%u</b>\
                      </p></span></body>",
                      CFSwapInt16BigToHost(tx3g->data_reference_index),
                      CFSwapInt32BigToHost(tx3g->display_flags) & 0x80000000 ? @"YES" : @"NO",
                      CFSwapInt32BigToHost(tx3g->display_flags) & 0x40000000 ? @"YES" : @"NO",
                      CFSwapInt32BigToHost(tx3g->display_flags) & 0x20000000 ? @"YES" : @"NO",
                      CFSwapInt16BigToHost(tx3g->default_text_box.top),
                      CFSwapInt16BigToHost(tx3g->default_text_box.left),
                      CFSwapInt16BigToHost(tx3g->default_text_box.bottom),
                      CFSwapInt16BigToHost(tx3g->default_text_box.right),
                      CFSwapInt16BigToHost(tx3g->font_identifier),
                      tx3g->font_face & 0x0001 ? @"YES" : @"NO",
                      tx3g->font_face & 0x0002 ? @"YES" : @"NO",
                      tx3g->font_face & 0x0004 ? @"YES" : @"NO",
                      tx3g->font_size,
                      CFSwapInt32BigToHost(tx3g->foreground_color)];
    return html;
}

@end
