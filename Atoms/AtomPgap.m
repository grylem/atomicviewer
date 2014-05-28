//
//  AtomPgap.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomPgap.h"

@implementation AtomPgap

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"pgap");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Gapless Playback",
                                      @"atomName",
                                      @"Atom pgap name");
}

- (NSString *)html
{
    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>%@</p></span></body>",
                      [self asBooleanString]];
    return html;
}

@end
