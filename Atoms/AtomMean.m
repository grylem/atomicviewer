//
//  AtomMean.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMean.h"

@implementation AtomMean

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"mean");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)html
{
    NSString *html = @"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>";

    NSUInteger maxLen = [[self data] length];
    maxLen = MIN(maxLen, 256);
    maxLen = strnlen([[self data] bytes], maxLen);
    NSString *nameString = [[NSString alloc] initWithBytes:[[self data] bytes] length:maxLen encoding:NSUTF8StringEncoding];
    html = [html stringByAppendingFormat:@"<b>%@</b>", nameString];
    html = [html stringByAppendingString:@"</p></span></body>"];
    return html;
}

@end
