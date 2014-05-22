//
//  AtomEnof.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/27/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomEnof.h"

#pragma pack(push,1)
typedef struct enof
{
    uint32_t width;
    uint32_t height;
} enof;
#pragma pack(pop)

@implementation AtomEnof

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"enof");
}

- (NSString *)atomName
{
    return (@"Track Encoded Pixels Dimensions");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    const struct enof *enof = [[self data] bytes];

    uint32_t width = CFSwapInt32BigToHost(enof->width);
    int16_t width_hi = width >> 16;
    int16_t width_lo = width & 0xffff;
    uint32_t height = CFSwapInt32BigToHost(enof->height);
    int16_t height_hi = height >> 16;
    int16_t height_lo = height & 0xffff;

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      Width: <b>%u.%u</b><br>\
                      Height: <b>%u.%u</b>\
                      </p></span></body>",
                      width_hi,
                      width_lo,
                      height_hi,
                      height_lo];
    return html;
}

@end
