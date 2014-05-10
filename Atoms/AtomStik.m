//
//  AtomStik.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomStik.h"

@implementation AtomStik

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"stik");
}

+(NSString *)atomName
{
    return (@"Media Kind");
}

- (NSString *)html
{
    NSString *mediaType;

    switch ([self asInteger]) {
        case 0:
            mediaType = @"Movie";
            break;
        case 1:
            mediaType = @"Music";
            break;
        case 2:
            mediaType = @"Audiobook";
            break;
        case 6:
            mediaType = @"Music Video";
            break;
        case 9:
            mediaType = @"Movie";
            break;
        case 10:
            mediaType = @"TV Show";
            break;
        case 11:
            mediaType = @"Booklet";
            break;
        case 14:
            mediaType = @"Ringtone";
            break;
        default:
            mediaType = @"Unknown";
            break;
    };
    NSString *htmlHeader = @"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>";
    NSString *htmlTrailer = @"</p></span></body>";
    NSString *string = [htmlHeader stringByAppendingString:mediaType];
    string = [string stringByAppendingString:htmlTrailer];
    return string;
}

@end
