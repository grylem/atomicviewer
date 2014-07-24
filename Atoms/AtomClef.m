//
//  AtomClef.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/27/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomClef.h"

@implementation AtomClef

#pragma pack(push,1)
typedef struct clef
{
    uint32_t width;
    uint32_t height;
} clef;
#pragma pack(pop)

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"clef");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Track Clean Aperture Dimensions",
                                      @"atomName",
                                      @"Atom clef name");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    const struct clef *clef = [[self data] bytes];

    uint32_t width = CFSwapInt32BigToHost(clef->width);
    int16_t width_hi = width >> 16;
    int16_t width_lo = width & 0xffff;
    uint32_t height = CFSwapInt32BigToHost(clef->height);
    int16_t height_hi = height >> 16;
    int16_t height_lo = height & 0xffff;

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      %@: <b>%@.%@</b><br>\
                      %@: <b>%@.%@</b>\
                      </p></span></body>",
                      NSLocalizedString(@"Width",nil),
                      @(width_hi),
                      @(width_lo),
                      NSLocalizedString(@"Height",nil),
                      @(height_hi),
                      @(height_lo)];
    return html;
}

@end
