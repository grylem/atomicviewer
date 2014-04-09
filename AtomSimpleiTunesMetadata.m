//
//  AtomSimpleiTunesMetadata.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 4/8/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomSimpleiTunesMetadata.h"
#import "AtomData.h"

@implementation AtomSimpleiTunesMetadata

//  This is the formatted textual explantion of the content of the atom
- (NSAttributedString *)decodedExplanation
{
    AtomData *dataAtom = (AtomData *)[self findChildAtomOfType: @"data"];
    NSString *string = [dataAtom asString];
    return [[NSAttributedString alloc] initWithString: string];
}

// The covr atom should be the only one with multiple children
// data atoms. They should all be images if more than one.
// Only need to test one.
//
// Note "has a" vs. "is a" notation. We may "have a" data atom
// that is an image, but that doesn't make us an image. On the other
// hand, it's fair to consider the data atom as an image if it
// represents an image.

-(BOOL)hasImage
{
    AtomData *dataAtom = (AtomData *)[self findChildAtomOfType:@"data"];
    return [dataAtom isImage];
}

// YES if we have a data atom representing an integer value
- (BOOL)hasInteger
{
    AtomData *dataAtom = (AtomData *)[self findChildAtomOfType:@"data"];
    return [dataAtom isInteger];
}

-(NSImage *)image
{
    if ([self hasImage]) {
        AtomData *dataAtom = (AtomData *)[self findChildAtomOfType: @"data"];
        return [dataAtom asImage];
    } else {
        return nil;
    }
}

@end
