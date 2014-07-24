//
//  AtomCo64.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomCo64.h"

@implementation AtomCo64

#pragma pack(push,1)
typedef struct co64
{
    uint32_t entry_count;
    uint64_t chunk_offset[];
}co64;
#pragma pack(pop)

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"co64");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Chunk Large Offset",
                                      @"atomName",
                                      @"Atom co64 name");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    const struct co64 *co64 = [[self data] bytes];

    NSString *html = [NSString stringWithFormat:@"<body>This atom contains offsets, from the beginning fo the file, to each chunk of media sample for this track.<br><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      <br>Number of chunks: <b>%@</b>\
                      <TABLE style=\"font-size:1.0em;\">\
                      <TR><TH>Chunk #</TH><TH>Chunk Offset</TH></TR>",
                      @(CFSwapInt32BigToHost(co64->entry_count))];

    uint32_t entry_count = MIN(CFSwapInt32BigToHost(co64->entry_count), 1000);
    for (uint32_t i=0; i<entry_count; i++) {
        @autoreleasepool {
            uint64_t offset = CFSwapInt64BigToHost(co64->chunk_offset[i]);
            html = [html stringByAppendingFormat:@"<TR><TD>%@</TD><TD ALIGN=RIGHT><b>%@</b></TD></TR>", @(i+1), @(offset)];
        }
    }
    html = [html stringByAppendingString:@"</TABLE></p></span></body>"];
    return html;
}

@end
