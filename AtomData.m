//
//  AtomData.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomData.h"

@implementation AtomData

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"data");
}

-(BOOL)isFullBox
{
    return YES;
}

#pragma mark - Representation in views

-(NSString *)atomName
{
    if ([self isiTunesMetadata]) {
        NSString *parentName = self.parent.atomName;
        return [@"Data for parent " stringByAppendingFormat:@"%@ atom", parentName];
    } else {
        return [super atomName];
    }
}

-(NSImage *)image
{
    return [self asImage];
}

// Only data for "covr" atom has an image

// Refactor this?
// Perhaps "covr" should ask its "data" for the image?
// This would allow covr to iterate over multiple data atoms
// and allow the data atom to validate the "well-known" data type.

-(BOOL)hasImage
{
    return [self isImage];
}

#pragma mark - iTunes Metadata data "well-known" type tests

- (BOOL)isImage
{
    return (
        self.flags == 13 || // JPG, PNG, or BMP
        self.flags == 14 ||
        self.flags == 27);
}

- (BOOL)isInteger
{
    return (
        self.flags == 21 || // Big-Endian Signed or Unsigned Integer, 1 to 4 bytes
        self.flags == 22);
}

- (BOOL)isFloat
{
    return (
        self.flags == 23 || // Big-Endian Float, 32 or 64 bits
        self.flags == 24);
}

- (BOOL)isString
{
    return (self.flags == 1);   // Right now, only support UTF-8 string
}

- (NSImage *)asImage
{
    if ([self isImage]) {
        [self.fileHandle seekToFileOffset: self.origin + 16];
        NSImage *image = [[NSImage alloc] initWithData:[self.fileHandle readDataOfLength:self.dataLength - 16]];
        return image;   // May return nil if NSImage -initWithData: fails
    } else {
        return nil; // I'm not an image
    }
}

- (NSString *)asString
{
    if ([self isString]) { // UTF-8 String
        [self.fileHandle seekToFileOffset: self.origin + 16];
        NSUInteger stringSize = self.dataLength - 16;
        NSData *stringData = [self.fileHandle readDataOfLength:stringSize];
        return [[NSString alloc]initWithBytes:[stringData bytes] length:stringSize encoding:NSUTF8StringEncoding];
    }
    return @"";
}

@end
