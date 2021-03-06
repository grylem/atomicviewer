//
//  AtomStsz.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomStsz.h"

@implementation AtomStsz

#pragma pack(push,1)
typedef struct stsz
{
    uint32_t sample_size; // default sample size. If all the same, this is it. If this == 0, then need to parse table below.
    uint32_t sample_count;
    uint32_t entry_size[];
}stsz;
#pragma pack(pop)

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"stsz");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Sample Size",
                                      @"atomName",
                                      @"Atom stsz name");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    const struct stsz *stsz = [[self data] bytes];
    uint32_t sample_count = CFSwapInt32BigToHost(stsz->sample_count);
    uint32_t default_size = CFSwapInt32BigToHost(stsz->sample_size);

    NSString *html = [NSString stringWithFormat:@"<body>%@<br><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      <br>%@: <b>%@</b>",
                      NSLocalizedString(@"This atom contains media sample sizes, either a constant size for all samples, or individual entries describing the size of each sample.",nil),
                      NSLocalizedString(@"Number of samples",nil),
                      @(sample_count)];

    if (default_size) {
        html = [html stringByAppendingFormat:@"<br>%@: <b>%@</b>",
                NSLocalizedString(@"Default Size",nil),
                @(default_size)];
    } else {
        html = [html stringByAppendingFormat:@"<TABLE style=\"font-size:1.0em;\">\
                <TR><TH>%@</TH><TH>%@</TH></TR>",
                NSLocalizedString(@"Sample #",nil),
                NSLocalizedString(@"Sample Size",nil)];
        sample_count = MIN(sample_count, 1000);
        for (uint32_t i=0; i<sample_count; i++) {
            @autoreleasepool {
                uint32_t offset = CFSwapInt32BigToHost(stsz->entry_size[i]);
                html = [html stringByAppendingFormat:@"<TR><TD>%@</TD><TD><b>%@</b></TD></TR>", @(i+1), @(offset)];
            }
        }
    }
    html = [html stringByAppendingString:@"</TABLE></p></span></body>"];
    return html;
}

@end
