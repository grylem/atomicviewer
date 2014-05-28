//
//  AtomUrl.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomUrl.h"

@implementation AtomUrl

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"url ");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Data Entry URL",
                                      @"atomName",
                                      @"Atom 'url ' name");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    BOOL self_contained = [self flags] & 1;

    if (self_contained) {
        return [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                %@\
                </p></span></body>",
                NSLocalizedString(@"URL Data Reference is self-contained.",nil)];
    } else {
        return @"";
    }
}

@end
