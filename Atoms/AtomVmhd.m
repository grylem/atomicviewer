//
//  AtomVmhd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomVmhd.h"

#pragma pack(push,1)
typedef struct vmhd
{
    uint16_t graphicsmode;
    struct {
        uint16_t red;
        uint16_t green;
        uint16_t blue;
    } opcolor;
} vmhd;
#pragma pack(pop)

@implementation AtomVmhd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"vmhd");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Video Media Header",
                                      @"atomName",
                                      @"Atom vmhd name");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    const struct vmhd *vmhd = [[self data] bytes];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      %@: <b>%@</b>\
                      <br>\
                      <br>%@: <b>%@</b>\
                      <br>%@: <b>%@</b>\
                      <br>%@: <b>%@</b>\
                      </p></span></body>",
                      NSLocalizedString(@"Graphics Mode",nil),
                      @(CFSwapInt16BigToHost(vmhd->graphicsmode)),
                      NSLocalizedString(@"Red",nil),
                      @(CFSwapInt16BigToHost(vmhd->opcolor.red)),
                      NSLocalizedString(@"Green",nil),
                      @(CFSwapInt16BigToHost(vmhd->opcolor.green)),
                      NSLocalizedString(@"Blue",nil),
                      @(CFSwapInt16BigToHost(vmhd->opcolor.blue))];
    return html;
}

@end
