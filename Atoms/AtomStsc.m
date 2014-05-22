//
//  AtomStsc.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomStsc.h"

@implementation AtomStsc

#pragma pack(push,1)
typedef struct stsc
{
    uint32_t entry_count;
    struct {
        uint32_t first_chunk;
        int32_t samples_per_chunk;
        uint32_t sample_description_index;
    } chunk[];
}stsc;
#pragma pack(pop)

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"stsc");
}

- (NSString *)atomName
{
    return (@"Sample To Chunk");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    const struct stsc *stsc = [[self data] bytes];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      <br>Number of entries: <b>%u</b>\
                      <TABLE style=\"font-size:1.0em;\">\
                      <TR><TH>Entry #</TH><TH>First chunk</TH><TH>Samples per chunk</TH><TH>Description Index</TH></TR>",
                      CFSwapInt32BigToHost(stsc->entry_count)];

    uint32_t entry_count = MIN(CFSwapInt32BigToHost(stsc->entry_count), 1000);
    for (uint32_t i=0; i<entry_count; i++) {
        @autoreleasepool {
            uint32_t first = CFSwapInt32BigToHost(stsc->chunk[i].first_chunk);
            uint32_t samples = CFSwapInt32BigToHost(stsc->chunk[i].samples_per_chunk);
            uint32_t desc_index = CFSwapInt32BigToHost(stsc->chunk[i].sample_description_index);
            html = [html stringByAppendingFormat:@"<TR><TD>%u</TD><TD ALIGN=RIGHT><b>%u</b></TD><TD ALIGN=RIGHT><b>%u</b></TD><TD ALIGN=RIGHT><b>%u</b></TD></TR>", i+1, first, samples, desc_index];
        }
    }
    html = [html stringByAppendingString:@"</TABLE></p></span></body>"];
    return html;
}

@end
