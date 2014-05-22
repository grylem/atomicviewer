//
//  AtomAvcC.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomAvcC.h"

#pragma pack(push,1)
typedef struct avcC
{
    uint8_t configurationVersion;
    uint8_t AVCProfileIndication;
    uint8_t profile_compatibility;
    uint8_t AVCLevelIndication;
    uint8_t lengthSizeMinusOne;
    uint8_t numOfSequenceParameterSets;
    struct sequenceParameterSet {
        uint16_t sequenceParameterSetLength;
        uint8_t sequenceParameterSetNALUnit[];
    };
    uint8_t numOfPictureParameterSets;
    struct pictureParameterSet {
        uint16_t pictureParameterSetLength;
        uint8_t pictureParameterSetNALUnit[];
    };
} avcC;
#pragma pack(pop)

@implementation AtomAvcC

static dispatch_once_t pred;
static NSDictionary *profileDict;

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"avcC");
}

- (NSString *)atomName
{
    return (@"AVC Configuration");
}

- (uint8_t)profileIndication
{
    const struct avcC *avcC_addr = [[self data] bytes];
    return avcC_addr->AVCProfileIndication;
}

- (NSString *)profileExplanation
{
    NSString *profile_explanation;

    dispatch_once (&pred, ^{
        profileDict = @{

                        @66  : @"Baseline",
                        @77  : @"Main",
                        @88  : @"Extended",
                        @100 : @"High",
                        @110 : @"High 10",
                        @122 : @"High 4:2:2",
                        @144 : @"High 4:4:4",
                        @244 : @"High 4:4:4 Predictive"
                        };
    });
    profile_explanation = profileDict[@([self profileIndication])];
    if (!profile_explanation) {
        profile_explanation = @"Unrecongnized";
    }
    return profile_explanation;
}

- (NSString *)html
{
    const struct avcC *avcC = [[self data] bytes];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      Configuration Version: <b>%u</b><br><br>\
                      AVC Profile Indication: <b>%u</b> (%@)<br>\
                      Profile Compatibility: <b>%u</b><br>\
                      AVC Level Indication: <b>%u</b> (%u.%u)<br><br>\
                      Length Size Minus One: <b>%u</b><br>\
                      Number of Sequence Parameter Sets: <b>%u</b>\
                      </p></span></body>",
                      avcC->configurationVersion,
                      avcC->AVCProfileIndication,
                      [self profileExplanation],
                      avcC->profile_compatibility,
                      avcC->AVCLevelIndication,
                      avcC->AVCLevelIndication / 10,
                      avcC->AVCLevelIndication % 10,
                      avcC->lengthSizeMinusOne & 0x03,
                      avcC->numOfSequenceParameterSets & 0x1F];
    return html;
}

@end
