//
//  AtomPasp.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomPasp.h"

#pragma pack(push,1)
typedef struct pasp
{
    uint32_t hSpacing;
    uint32_t vSpacing;
}pasp;
#pragma pack(pop)

@implementation AtomPasp

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"pasp");
}

- (NSString *)atomName
{
    return (@"Pixel Aspect Ratio");
}

- (NSString *)html
{
    const struct pasp *pasp = [[self data] bytes];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      hSpacing: <b>%u</b><br>\
                      vSpacing: <b>%u</b><br>\
                      </p></span></body>",
                      CFSwapInt32BigToHost(pasp->hSpacing),
                      CFSwapInt32BigToHost(pasp->vSpacing)];
    return html;
}

@end
