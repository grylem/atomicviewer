//
//  AtomSchm.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomSchm.h"

@implementation AtomSchm

#pragma pack(push,1)
typedef struct schm
{
    uint32_t scheme_type;
    uint32_t scheme_version;
    uint8_t scheme_uri[];        // only if low-order bit of flags is set
} schm;
#pragma pack(pop)

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"schm");
}

- (NSString *)atomName
{
    return (@"Scheme Type");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    const schm *scheme = [[self data] bytes];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      Scheme type: <b>%@</b>\
                      </p></span></body>",
                      [self stringFromFourCC:&scheme->scheme_type]];
    return html;
}

@end
