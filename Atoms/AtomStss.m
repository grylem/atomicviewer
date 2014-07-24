//
//  AtomStss.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomStss.h"

@implementation AtomStss

#pragma pack(push,1)
typedef struct stss
{
    uint32_t entry_count;
    uint32_t sample_number[];
}stss;
#pragma pack(pop)

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"stss");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Sync Sample",
                                      @"atomName",
                                      @"Atom stss name");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    const struct stss *stss = [[self data] bytes];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p><br>\
                      %@: <b>%@</b>\
                      <TABLE style=\"font-size:1.0em;\">\
                      <TR><TH>%@</TH><TH>%@</TH></TR>",
                      NSLocalizedString(@"Number of entries",nil),
                      @(CFSwapInt32BigToHost(stss->entry_count)),
                      NSLocalizedString(@"Entry #",nil),
                      NSLocalizedString(@"Sample Number",nil)];

    uint32_t entry_count = MIN(CFSwapInt32BigToHost(stss->entry_count), 1000);
    for (uint32_t i=0; i<entry_count; i++) {
        @autoreleasepool {
            html = [html stringByAppendingFormat:@"<TR><TD>%@</TD><TD><b>%@</b></TD></TR>",
                    @(i+1),
                    @(CFSwapInt32BigToHost(stss->sample_number[i]))];
        }
    }
    html = [html stringByAppendingString:@"</TABLE></p></span></body>"];
    return html;
}

@end
