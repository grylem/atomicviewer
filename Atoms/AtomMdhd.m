//
//  AtomMdhd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMdhd.h"
#import "AtomMvhd.h"

#pragma pack(push,1)
typedef struct mdhd_ver0
{
    uint32_t  creation_time;
    uint32_t  modification_time;
    uint32_t  timescale;
    uint32_t  duration;
    uint16_t language; // packed ISO-639-2/T language code
    uint16_t pre_defined; // = 0
} mdhd_ver0;

typedef struct mdhd_ver1
{
    uint64_t  creation_time;
    uint64_t  modification_time;
    uint32_t  timescale;
    uint64_t  duration;
    uint16_t language; // packed ISO-639-2/T language code
    uint16_t pre_defined; // = 0
} mdhd_ver1;
#pragma pack(pop)

@implementation AtomMdhd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mdhd");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Media Header",
                                      @"atomName",
                                      @"Atom mdhd name");
}

-(BOOL)isFullBox
{
    return YES;
}

- (uint32_t)timescale
{
    const mdhd_ver0 *mdhd = [[self data] bytes];
    return CFSwapInt32BigToHost(mdhd->timescale);
}

- (NSString *)html
{
    NSDate *creationDate;
    NSDate *modificationDate;
    uint64_t duration;
    uint16_t hours;
    uint16_t minutes;
    double seconds;
    char language[4];

    const mdhd_ver0 *mdhd = [[self data] bytes];

    creationDate = [self getUInt32TimeValueAtOffset:offsetof(struct mdhd_ver0, creation_time)];
    modificationDate = [self getUInt32TimeValueAtOffset:offsetof(struct mdhd_ver0, modification_time)];
    duration = [self getUInt32DurationValueAtOffset: offsetof(struct mdhd_ver0, duration)
                                     usingTimescale: [self timescale]
                                              hours: &hours
                                            minutes: &minutes
                                            seconds: &seconds];
    uint16_t languageUint16 = CFSwapInt32BigToHost(mdhd->language);
    language[0] = ((languageUint16 & 0x7c00) >> 10) + 0x60;
    language[1] = ((languageUint16 & 0x03e0) >> 5) + 0x60;
    language[2] = ((languageUint16 & 0x001f)) + 0x60;
    language[3] = 0;

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      %@: <b>%@</b><br>\
                      %@: <b>%@</b><br>\
                      %@: <b>%u</b><br>\
                      %@: <b>%llu (%02u:%02u:%09.6f)</b><br>\
                      %@: <b>%s</b><br>\
                      </p></span></body>",
                      NSLocalizedString(@"Creation date",nil),
                      creationDate,
                      NSLocalizedString(@"Modification date",nil),
                      modificationDate,
                      NSLocalizedString(@"Timescale",nil),
                      [self timescale],
                      NSLocalizedString(@"Duration",nil),
                      duration, hours, minutes, seconds,
                      NSLocalizedString(@"Language",nil),
                      languageUint16 ? language : "(None)"];

    return html;

}
@end
