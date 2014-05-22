//
//  AtomFall.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomFall.h"

// This is a track reference atom.
// I haven't seen a definition of this atom yet, but given the context in which it's used (tref),
// the data is likely an array of Track IDs

@implementation AtomFall

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"fall");
}

- (NSString *)atomName
{
    return (@"Alternate Audio Track Reference");
}

- (NSString *)html
{
    NSString *html = @"<body>This track reference refers to an alternate audio track in an alternate format, but with identical content.<br>\
    This is often used with a Surround Sound track to refer to a Stereo track for devices that cannot decode Surround audio.\
    <span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>";

    NSUInteger count = [[self data] length] / sizeof(uint32_t);

    for (NSUInteger i=0; i<count; i++) {
        uint32_t track = CFSwapInt32BigToHost(*(uint32_t *)([[self data] bytes] + (i * sizeof(uint32_t))));
        html = [html stringByAppendingFormat:@"<br>Track Number: <b>%u</b>", track];

    }
    html = [html stringByAppendingString:@"</p></span></body>"];
    return html;
}

@end
