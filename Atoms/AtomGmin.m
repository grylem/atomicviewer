//
//  AtomGmin.m
//  AtomicViewer
//
//  Created by Jay O'Conor on 5/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomGmin.h"

#pragma pack(push,1)
typedef struct gmin
{
    uint16_t graphics_mode;
    struct {
        uint16_t red;
        uint16_t green;
        uint16_t blue;
    } opcolor;
    uint16_t balance;
    uint16_t reserved;
}gmin;
#pragma pack(pop)

@implementation AtomGmin

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"gmin");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Base Media Information",
                                      @"atomName",
                                      @"Atom gmin name");
}

- (BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    const gmin *gmin = [[self data] bytes];
    uint8_t balance_hi;
    uint8_t balance_lo;

    [self get88ValueAtOffset:offsetof(struct gmin, balance) hi:&balance_hi lo:&balance_lo];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      %@: <b>%u</b><br>\
                      <br>\
                      %@: <b>%u</b><br>\
                      %@: <b>%u</b><br>\
                      %@: <b>%u</b><br>\
                      <br>\
                      %@: <b>%u.%u</b>\
                      </p></span></body>",
                      NSLocalizedString(@"GraphicsMode",nil),
                      CFSwapInt16BigToHost(gmin->graphics_mode),
                      NSLocalizedString(@"Red",nil),
                      CFSwapInt16BigToHost(gmin->opcolor.red),
                      NSLocalizedString(@"Green",nil),
                      CFSwapInt16BigToHost(gmin->opcolor.green),
                      NSLocalizedString(@"Blue",nil),
                      CFSwapInt16BigToHost(gmin->opcolor.blue),
                      NSLocalizedString(@"Balance",nil),
                      balance_hi,
                      balance_lo];
    return html;
}

@end
