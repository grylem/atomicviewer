//
//  AtomAkID.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/24/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomAkID.h"

@implementation AtomAkID

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"akID");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"iTunes Store Account Type",
                                      @"atomName",
                                      @"Atom akID name");
}

- (NSString *)html
{
    NSString *accountType;

    switch ([self asInteger]) {
        case 0:
            accountType = NSLocalizedString(@"iTunes",
                                            @"iTunes Store Account Type");
            break;
        case 1:
            accountType = NSLocalizedString(@"AOL",
                                            @"iTunes Store Account Type");
            break;
        default:
            accountType = NSLocalizedString(@"Unknown Account Type",
                                            @"iTunes Store Account Type");
            break;
    };
    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      %@\
                      </p></span></body>",
                      accountType];
    return html;
}

@end
