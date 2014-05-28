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

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Media Kind",
                                      @"atomName",
                                      @"Atom stik name");
}

- (NSString *)html
{
    NSString *mediaType;

    switch ([self asInteger]) {
        case 0:
            mediaType = NSLocalizedStringFromTable(@"Movie",@"stik",@"Media Kind");
            break;
        case 1:
            mediaType = NSLocalizedStringFromTable(@"Music",@"stik",@"Media Kind");
            break;
        case 2:
            mediaType = NSLocalizedStringFromTable(@"Audiobook",@"stik",@"Media Kind");
            break;
        case 6:
            mediaType = NSLocalizedStringFromTable(@"Music Video",@"stik",@"Media Kind");
            break;
        case 9:
            mediaType = NSLocalizedStringFromTable(@"Movie",@"stik",@"Media Kind");
            break;
        case 10:
            mediaType = NSLocalizedStringFromTable(@"TV Show",@"stik",@"Media Kind");
            break;
        case 11:
            mediaType = NSLocalizedStringFromTable(@"Booklet",@"stik",@"Media Kind");
            break;
        case 14:
            mediaType = NSLocalizedStringFromTable(@"Ringtone",@"stik",@"Media Kind");
            break;
        default:
            mediaType = NSLocalizedStringFromTable(@"Unknown Media Kind",@"stik",@"Media Kind");
            break;
    };
    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>%@</p></span></body>",
                      mediaType];
    return html;
}

@end
