//
//  AtomEsds.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomEsds.h"

@implementation AtomEsds

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"esds");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)atomName
{
    return (@"Elementary Stream Descriptor");
}

- (NSString *)html
{
    NSString *html = @"<body>This atom contains an Elementary Stream Descriptor, as defined in ISO/IEC 14496-1 &sect 8.6.5. This is typically used to describe an AAC (a.k.a. \"mp4a\") stream. No interpretation is provided at this time.<br><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>";
    html = [html stringByAppendingString:@"</p></span></body>"];
    return html;
}

@end
