//
//  AtomFrma.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomFrma.h"

@implementation AtomFrma

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"frma");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Original Format",
                                      @"atomName",
                                      @"Atom frma name");
}

- (NSString *)html
{
    NSString *html = [NSString stringWithFormat: @"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      %@: <b>%@</b>\
                      </p></span></body>",
                      NSLocalizedString(@"Original Format",nil),
                      [self stringFromFourCC:[[self data]bytes]]];
    
    return html;
}

@end
