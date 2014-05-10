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

+(NSString *)atomName
{
    return (@"Gapless Playback");
}

- (NSString *)html
{
    NSString *htmlHeader = @"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>";
    NSString *htmlTrailer = @"</p></span></body>";
    NSString *string = [htmlHeader stringByAppendingString:[self asBooleanString]];
    string = [string stringByAppendingString:htmlTrailer];
    return string;
}

@end
