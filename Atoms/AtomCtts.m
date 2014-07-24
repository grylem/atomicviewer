//
//  AtomCtts.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomCtts.h"

@implementation AtomCtts

#pragma pack(push,1)
typedef struct ctts
{
    uint32_t entry_count;
    struct {
        uint32_t sample_count;
        uint32_t sample_offset;
    } sample[];
}ctts;
#pragma pack(pop)

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"ctts");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Composition Time to Sample",
                                      @"atomName",
                                      @"Atom ctts name");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    const struct ctts *ctts = [[self data] bytes];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p><br>\
                      %@: <b>%@</b>\
                      <TABLE style=\"font-size:1.0em;\">\
                      <TR><TH>%@</TH><TH>%@</TH></TR>",
                      NSLocalizedString(@"Number of entries",nil),
                      @(CFSwapInt32BigToHost(ctts->entry_count)),
                      NSLocalizedString(@"Sample Count",nil),
                      NSLocalizedString(@"Sample Delta",nil)];

    uint32_t entry_count = MIN(CFSwapInt32BigToHost(ctts->entry_count), 1000);
    for (uint32_t i=0; i<entry_count; i++) {
        @autoreleasepool {
            html = [html stringByAppendingFormat:@"<TR><TD><b>%@</b></TD><TD><b>%@</b></TD></TR>",
                    @(CFSwapInt32BigToHost(ctts->sample[i].sample_count)),
                    @(CFSwapInt32BigToHost(ctts->sample[i].sample_offset))];
        }
    }
    html = [html stringByAppendingString:@"</TABLE></p></span></body>"];
    return html;
}

@end
