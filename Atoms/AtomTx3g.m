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
    return NSLocalizedStringFromTable(@"Subtitle Sample Description",
                                      @"atomName",
                                      @"Atom tx3g name");
}

-(NSUInteger) jump
{
    return sizeof(struct tx3g);
}

- (NSString *)html
{
    const tx3g *tx3g = [[self data] bytes];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      %@: <b>%@</b><br>\
                      %@: <b>%@</b><br>\
                      %@: <b>%@</b><br>\
                      %@: <b>%@</b><br>\
                      %@: <b>%@</b><br>\
                      %@: <b>%@</b><br>\
                      %@: <b>%@</b><br>\
                      %@: <b>%@</b><br>\
                      %@: <b>%@</b><br>\
                      %@: <b>%@</b><br>\
                      %@: <b>%@</b><br>\
                      %@: <b>%@</b><br>\
                      %@: <b>%@</b><br>\
                      %@: <b>%@</b>\
                      </p></span></body>",
                      NSLocalizedString(@"Data Reference Index",nil),
                      @(CFSwapInt16BigToHost(tx3g->data_reference_index)),
                      NSLocalizedString(@"All Samples are Forced",nil),
                      CFSwapInt32BigToHost(tx3g->display_flags) & 0x80000000 ? NSLocalizedString(@"YES",nil) : NSLocalizedString(@"NO",nil),
                      NSLocalizedString(@"Some Samples are Forced",nil),
                      CFSwapInt32BigToHost(tx3g->display_flags) & 0x40000000 ? NSLocalizedString(@"YES",nil) : NSLocalizedString(@"NO",nil),
                      NSLocalizedString(@"Vertical Placement",nil),
                      CFSwapInt32BigToHost(tx3g->display_flags) & 0x20000000 ? NSLocalizedString(@"YES",nil) : NSLocalizedString(@"NO",nil),
                      NSLocalizedString(@"Text Box Top",nil),
                      @(CFSwapInt16BigToHost(tx3g->default_text_box.top)),
                      NSLocalizedString(@"Text Box Left",nil),
                      @(CFSwapInt16BigToHost(tx3g->default_text_box.left)),
                      NSLocalizedString(@"Text Box Bottom",nil),
                      @(CFSwapInt16BigToHost(tx3g->default_text_box.bottom)),
                      NSLocalizedString(@"Text Box Right",nil),
                      @(CFSwapInt16BigToHost(tx3g->default_text_box.right)),
                      NSLocalizedString(@"Font Identifier",nil),
                      @(CFSwapInt16BigToHost(tx3g->font_identifier)),
                      NSLocalizedString(@"Font Face Bold",nil),
                      tx3g->font_face & 0x01 ? NSLocalizedString(@"YES",nil) : NSLocalizedString(@"NO",nil),
                      NSLocalizedString(@"Font Face Italic",nil),
                      tx3g->font_face & 0x02 ? NSLocalizedString(@"YES",nil) : NSLocalizedString(@"NO",nil),
                      NSLocalizedString(@"Font Face Underline",nil),
                      tx3g->font_face & 0x04 ? NSLocalizedString(@"YES",nil) : NSLocalizedString(@"NO",nil),
                      NSLocalizedString(@"Font Size",nil),
                      @(tx3g->font_size),
                      NSLocalizedString(@"Foreground Color",nil),
                      @(CFSwapInt32BigToHost(tx3g->foreground_color))];
    return html;
}

@end
