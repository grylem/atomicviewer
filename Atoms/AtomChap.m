//
//  AtomChap.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomChap.h"

@implementation AtomChap

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"chap");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Chapter Track Reference",
                                      @"atomName",
                                      @"Atom chap name");
}

- (NSString *)html
{
    NSString *html = @"<body>This atom contains a track reference to the chapter track.<br><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>";

    NSUInteger count = [[self data] length] / sizeof(uint32_t);

    for (NSUInteger i=0; i<count; i++) {
        uint32_t track = CFSwapInt32BigToHost(*(uint32_t *)([[self data] bytes] + (i * sizeof(uint32_t))));
        html = [html stringByAppendingFormat:@"<br>%@: <b>%@</b>",
                NSLocalizedString(@"Track Number", nil),
                @(track)];

    }
    html = [html stringByAppendingString:@"</p></span></body>"];
    return html;
}

@end
