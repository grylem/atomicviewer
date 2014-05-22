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
    return (@"Subtitle Follows Track Reference");
}

- (NSString *)html
{
    NSString *html = @"<body>This atom contains a track reference for the default subtitle track to be used for this audio track.<br><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>";

    NSUInteger count = [[self data] length] / sizeof(uint32_t);

    for (NSUInteger i=0; i<count; i++) {
        uint32_t track = CFSwapInt32BigToHost(*(uint32_t *)([[self data] bytes] + (i * sizeof(uint32_t))));
        html = [html stringByAppendingFormat:@"<br>Track Number: <b>%u</b>", track];

    }
    html = [html stringByAppendingString:@"</p></span></body>"];
    return html;
}

@end
