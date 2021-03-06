//
//  AtomName.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

// Ok, so name is going to be a problem.
// The name atom can occur as a child of
// ----, udta, or schi.
// When a child of udta or schi, name is a simple
// atom. When a child of ----, it's versioned.

#import "AtomName.h"

@implementation AtomName

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"name");
}

// Name atom is used in different contexts.
// Only when it's part of iTunes metadata do we know we have version & flags

-(BOOL)isFullBox
{
    return [self isImmediateDescendantOf:@"----"];
}

- (NSString *)asString
{
    NSUInteger maxLen = MIN([[self data] length], 256);
    maxLen = strnlen([[self data] bytes], maxLen);
    return [[NSString alloc] initWithBytes:[[self data] bytes] length: maxLen encoding:NSUTF8StringEncoding];
}

- (NSString *)html
{
    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      <b>%@</b>\
                      </p></span></body>",
                      [self asString]];
    return html;
}

@end
