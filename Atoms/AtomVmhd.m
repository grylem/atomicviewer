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
    return (@"Video Media Header");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    const struct vmhd *vmhd = [[self data] bytes];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      Graphics Mode: <b>%u</b>\
                      <br>\
                      <br>Red: <b>%u</b>\
                      <br>Green: <b>%u</b>\
                      <br>Blue: <b>%u</b>\
                      </p></span></body>",
                      CFSwapInt16BigToHost(vmhd->graphicsmode),
                      CFSwapInt16BigToHost(vmhd->opcolor.red),
                      CFSwapInt16BigToHost(vmhd->opcolor.green),
                      CFSwapInt16BigToHost(vmhd->opcolor.blue)];
    return html;
}

@end
