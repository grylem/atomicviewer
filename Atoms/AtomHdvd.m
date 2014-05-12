//
//  AtomHdvd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomHdvd.h"

@implementation AtomHdvd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"hdvd");
}

- (NSString *)atomName
{
    return (@"HD Video");
}

- (NSString *)html
{
    NSString *resolutionType;

    switch ([self asInteger]) {
        case 0:
            resolutionType = @"SD Video";
            break;
        case 1:
            resolutionType = @"HD Video: 720p";
            break;
        default:
            resolutionType = @"HD Video: 1080p";
            break;
    };
    NSString *htmlHeader = @"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>";
    NSString *htmlTrailer = @"</p></span></body>";
    NSString *string = [htmlHeader stringByAppendingString:resolutionType];
    string = [string stringByAppendingString:htmlTrailer];
    return string;
}

@end
