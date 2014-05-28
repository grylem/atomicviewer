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
    return NSLocalizedStringFromTable(@"HD Video",
                                      @"atomName",
                                      @"Atom hdvd name");
}

- (NSString *)html
{
    NSString *resolutionType;

    switch ([self asInteger]) {
        case 0:
            resolutionType = NSLocalizedString(@"SD Video",nil);
            break;
        case 1:
            resolutionType = NSLocalizedString(@"HD Video: 720p",nil);
            break;
        default:
            resolutionType = NSLocalizedString(@"HD Video: 1080p",nil);
            break;
    };

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>%@</p></span></body>",
                      resolutionType];
    return html;
}

@end
