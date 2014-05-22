//
//  AtomFtab.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/23/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomFtab.h"

#pragma pack(push,1)
typedef struct ftab
{
    uint16_t count;
    uint16_t font_identifier;
    uint8_t font_name_length;
    uint8_t font_name[];
}ftab;
#pragma pack(pop)

@implementation AtomFtab

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"ftab");
}

- (NSString *)atomName
{
    return @"Font Table";
}

- (NSString *)html
{
    const ftab *ftab = [[self data] bytes];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      Font Identifier: <b>%u</b><br>\
                      Font Name: <b>%@</b>",
                      CFSwapInt16BigToHost(ftab->font_identifier),
                      [[NSString alloc] initWithBytes:(ftab->font_name)
                                               length:ftab->font_name_length
                                             encoding:NSUTF8StringEncoding]];
    return html;
}
@end
