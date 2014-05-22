//
//  AtomSmhd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomSmhd.h"

@implementation AtomSmhd

#pragma pack(push,1)
typedef struct smhd
{
    uint16_t balance;
} smhd;
#pragma pack(pop)

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"smhd");
}

- (NSString *)atomName
{
    return (@"Sound Media Header");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    uint8_t balance_hi;
    uint8_t balance_lo;

    [self get88ValueAtOffset:offsetof(struct smhd, balance) hi:&balance_hi lo:&balance_lo];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      Balance: <b>%u.%u</b>\
                      </p></span></body>",
                      balance_hi,
                      balance_lo];
    return html;
}

@end
