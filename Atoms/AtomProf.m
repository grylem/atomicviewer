//
//  AtomProf.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/27/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomProf.h"

#pragma pack(push,1)
typedef struct prof
{
    uint32_t width;
    uint32_t height;
} prof;
#pragma pack(pop)

@implementation AtomProf

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"prof");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Track Production Aperture Dimensions",
                                      @"atomName",
                                      @"Atom prof name");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    const struct prof *prof = [[self data] bytes];

    uint32_t width = CFSwapInt32BigToHost(prof->width);
    int16_t width_hi = width >> 16;
    int16_t width_lo = width & 0xffff;
    uint32_t height = CFSwapInt32BigToHost(prof->height);
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
