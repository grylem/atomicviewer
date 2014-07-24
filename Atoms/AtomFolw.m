//
//  AtomFolw.m
//  AtomicViewer
//
//  Created by Jay O'Conor on 5/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomFolw.h"

@implementation AtomFolw

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"folw");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Subtitle Follows Track Reference",
                                      @"atomName",
                                      @"Atom folw name");
}

- (NSString *)html
{
    NSString *html = [NSString stringWithFormat:@"<body>%@<span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>",
                      NSLocalizedString(@"This atom contains a track reference for the default subtitle track to be used for this audio track.",nil)];

    NSUInteger count = [[self data] length] / sizeof(uint32_t);

    for (NSUInteger i=0; i<count; i++) {
        uint32_t track = CFSwapInt32BigToHost(*(uint32_t *)([[self data] bytes] + (i * sizeof(uint32_t))));
        html = [html stringByAppendingFormat:@"<br>%@: <b>%@</b>",
                NSLocalizedString(@"Track Number",nil),
                @(track)];

    }
    html = [html stringByAppendingString:@"</p></span></body>"];
    return html;
}

@end
