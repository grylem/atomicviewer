//
//  AtomStco.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomStco.h"

@implementation AtomStco

#pragma pack(push,1)
typedef struct stco
{
    uint32_t entry_count;
    uint32_t chunk_offset[];
}stco;
#pragma pack(pop)

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"stco");
}

- (NSString *)atomName
{
    return (@"Chunk Offset");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    const struct stco *stco = [[self data] bytes];

    NSString *html = [NSString stringWithFormat:@"<body>This atom contains offsets, from the beginning fo the file, to each chunk of media samples for this track.<br><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      <br>Number of chunks: <b>%u</b>\
                      <TABLE style=\"font-size:1.0em;\">\
                      <TR><TH>Chunk #</TH><TH>Chunk Offset</TH></TR>",
                      CFSwapInt32BigToHost(stco->entry_count)];

    uint32_t entry_count = MIN(CFSwapInt32BigToHost(stco->entry_count), 1000);
    for (uint32_t i=0; i<entry_count; i++) {
        @autoreleasepool {
            uint32_t offset = CFSwapInt32BigToHost(stco->chunk_offset[i]);
            html = [html stringByAppendingFormat:@"<TR><TD>%u</TD><TD ALIGN=RIGHT><b>%u</b></TD></TR>", i+1, offset];
        }
    }
    html = [html stringByAppendingString:@"</TABLE></p></span></body>"];
    return html;
}

@end
