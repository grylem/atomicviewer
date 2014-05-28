//
//  AtomColr.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomColr.h"

#pragma pack(push,1)
typedef struct colr
{
    char type[4];
    uint16_t primaries_index;
    uint16_t transfer_function_index;
    uint16_t matrix_index;
}colr;
#pragma pack(pop)

@implementation AtomColr

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"colr");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Color Parameter",
                                      @"atomName",
                                      @"Atom colr name");
}

- (NSString *)html
{
    const struct colr *colr = [[self data] bytes];
    NSString *type = [self stringFromFourCC:(colr->type)];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      %@: <b>%@</b><br>\
                      %@: <b>%u</b><br>\
                      %@: <b>%u</b><br>\
                      %@: <b>%u</b><br>\
                      </p></span></body>",
                      NSLocalizedString(@"Color Parameter Type",nil),
                      type,
                      NSLocalizedString(@"Primaries Index",nil),
                      CFSwapInt16BigToHost(colr->primaries_index),
                      NSLocalizedString(@"Transfer Function Index",nil),
                      CFSwapInt16BigToHost(colr->transfer_function_index),
                      NSLocalizedString(@"Matrix Index",nil),
                      CFSwapInt16BigToHost(colr->matrix_index)];
    return html;
}

@end
