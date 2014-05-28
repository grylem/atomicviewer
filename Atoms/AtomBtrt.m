//
//  AtomBtrt.m
//  AtomicViewer
//
//  Created by Jay O'Conor on 5/26/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomBtrt.h"

@implementation AtomBtrt

#pragma pack(push,1)
typedef struct btrt {
    uint32_t bufferSizeDB;
    uint32_t maxBitrate;
    uint32_t avgBitrate;
} btrt;
#pragma pack(pop)

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"btrt");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Bit Rate",
                                      @"atomName",
                                      @"Atom btrt name");
}

- (NSString *)html
{
    const btrt *btrt = [[self data] bytes];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      <br>%@: <b>%u</b>\
                      <br>%@: <b>%u</b>\
                      <br>%@: <b>%u</b>\
                      </p></span></body>",
                      NSLocalizedString(@"Decoding Buffer Size", nil),
                      CFSwapInt32BigToHost(btrt->bufferSizeDB),
                      NSLocalizedString(@"Max Bitrate", nil),
                      CFSwapInt32BigToHost(btrt->maxBitrate),
                      NSLocalizedString(@"Average Bitrate", nil),
                      CFSwapInt32BigToHost(btrt->avgBitrate)];
    return html;
}

@end
