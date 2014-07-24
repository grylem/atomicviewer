//
//  AtomWide.m
//  AtomicViewer
//
//  Created by Jay O'Conor on 7/1/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomWide.h"

@implementation AtomWide

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"wide");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Reserved Space for following atom",
                                      @"atomName",
                                      @"Reserved Space for following atom");
}

- (NSString *)html
{
    NSString *html = @"<body>This atom reserves 8 bytes of space to allow the atom following this one to be extended to use an extended length, if it should become necessary, without having to rewrite the entire file.<br><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>";

    html = [html stringByAppendingString:@"</p></span></body>"];
    return html;
}

@end
