//
//  AtomElng.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomElng.h"

@implementation AtomElng

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"elng");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Extended Language Tag",
                                      @"atomName",
                                      @"Atom elng name");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      %@: <b>%s</b>\
                      </p></span></body>",
                      NSLocalizedString(@"Extended Language",nil),
                      [[self data] bytes]];
    return html;
}

@end
