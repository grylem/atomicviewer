//
//  AtomSimpleiTunesMetadata.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 4/8/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom_iTMF.h"
#import "AtomData.h"

@implementation Atom_iTMF

// If an iTunes metadata atom is used outside the context of the iTunes metadata atom hierarchy (e.g., in a QuickTime file), don't assume it has child atom(s).
- (BOOL)isLeaf
{
    return (![self isiTunesMetadata]);
}

//  This is the formatted textual explantion of the content of the atom
- (NSString *)html
{
    if ([self isiTunesMetadata]) {
        AtomData *dataAtom = (AtomData *)[self findChildAtomOfType: @"data"];
        NSString *htmlHeader = @"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>";
        NSString *htmlTrailer = @"</p></span></body>";
        NSString *string = [htmlHeader stringByAppendingString: [dataAtom asString]];
        string = [string stringByAppendingString:htmlTrailer];
        return string;
    } else {
        return nil;
    }
}

- (NSString *)asBooleanString
{
    NSString *string = [[NSString alloc]initWithFormat:@"%@",([self asInteger]?@"YES":@"NO") ];

    return string;
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

-(UInt16)getUInt16ValueAtOffset:(off_t)offset
{
    UInt16 result;
    NSRange uint16DataRange = NSMakeRange(offset, 2);
    AtomData *dataAtom = (AtomData *)[self findChildAtomOfType: @"data"];
    [dataAtom.data getBytes:&result range:uint16DataRange];
    result = NSSwapBigShortToHost(result);

    return result;
}

-(NSInteger)asInteger
{
    AtomData *dataAtom = (AtomData *)[self findChildAtomOfType: @"data"];
    return [dataAtom asInteger];
}

- (NSString *)asString
{
    AtomData *dataAtom = (AtomData *)[self findChildAtomOfType: @"data"];
    return [dataAtom asString];
}

- (NSData *)data
{
    AtomData *dataAtom = (AtomData *)[self findChildAtomOfType: @"data"];
    return [dataAtom data];
}

@end
