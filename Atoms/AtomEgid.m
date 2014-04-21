//
//  AtomEgid.m
//  AtomicViewer
//
//  Created by Jay O'Conor on 4/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

// Not really sure what this atom is for.
// In the wild, I'm seeing a URL in this
// atom, in WWDC videos.

// Although the data is text, it is not typed
// with either of the "well-known" types for
// text. This is probably because the text
// types are all UTF encodings. This further
// supports the premise that this atom is for
// a URL only, as URLs must be printable ASCII
// encoded.

#import "AtomEgid.h"

@implementation AtomEgid

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"egid");
}

- (NSAttributedString *)decodedExplanation
{
    NSData *data = [self data];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    return [[NSAttributedString alloc] initWithString: string];
}

@end
