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
    return NSLocalizedStringFromTable(@"Content Advisory",
                                      @"atomName",
                                      @"Atom rtng name");
}

- (NSString *)html
{
    NSString *rtng;

    switch ([self asInteger]) {
        case 0:
            rtng = NSLocalizedString(@"None",
                                     @"Content Advisory");
            break;
        case 1:
            rtng = NSLocalizedString(@"Explicit",
                                     @"Content Advisory");
            break;
        case 2:
            rtng = NSLocalizedString(@"Clean",
                                     @"Content Advisory");
            break;
//        case 4:
//            rtng = NSLocalizedString(@"Explicit",
//                                     @"Content Advisory");
//            break;
        default:
            rtng = NSLocalizedString(@"Unknown Content Advisory",
                                     @"Content Advisory");
            break;
    };
    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      %@\
                      </p></span></body>",
                      rtng];
    return html;
}

@end
