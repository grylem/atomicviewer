//
//  AtomRtng.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomRtng.h"

@implementation AtomRtng

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"rtng");
}

- (NSString *)atomName
{
    return (@"Content Advisory");
}

- (NSString *)html
{
    NSString *rtng;

    switch ([self asInteger]) {
        case 0:
            rtng = @"None";
            break;
        case 1:
            rtng = @"Explicit";
            break;
        case 2:
            rtng = @"Clean";
            break;
//        case 4:
//            rtng = @"Explicit";
//            break;
        default:
            rtng = @"Unknown";
            break;
    };
    return rtng;
}

@end
