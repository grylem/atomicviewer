//
//  AtomForc.m
//  AtomicViewer
//
//  Created by Jay O'Conor on 5/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomForc.h"

#pragma pack(push,1)
typedef struct forc
{
    uint32_t track;
} forc;
#pragma pack(pop)

@implementation AtomForc

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"forc");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Forced Subtitle Track Reference",
                                      @"atomName",
                                      @"Atom forc name");
}

- (NSString *)html
{
    const forc *forc = [[self data] bytes];

    NSString *html = [NSString stringWithFormat:@"<body>%@<br><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      <br>%@: <b>%u</b>\
                      </p></span></body>",
                      NSLocalizedString(@"This atom contains a track reference to a forced subtitle track.",nil),
                      NSLocalizedString(@"Track Number", nil),
                      CFSwapInt32BigToHost(forc->track)];
    return html;
}

@end
