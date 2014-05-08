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
        NSString *parentType = self.parent.atomType;
        return [@"Data for parent " stringByAppendingFormat:@"%@ atom", parentType];
    } else {
        return [super atomName];
    }
}

-(NSImage *)image
{
    return [self asImage];
}

- (NSString *)html
{
    if ([self isString]) {
        NSString *string = @"<xmp>";
        string = [string stringByAppendingString:[self asString]];
        string = [string stringByAppendingString:@"</xmp>"];
        return string;
    } else if ([self isInteger]) {
        return [[NSString alloc] initWithFormat:@"%ld",(long)[self asInteger]];
    }
    return @"";
}

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
        self.flags == 21 || // Big-Endian Signed or Unsigned Integer, 1,2,4,8 bytes
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
        // May return nil if NSImage -initWithData: fails
        return[[NSImage alloc] initWithData:[NSData dataWithBytes:[self.data bytes] + 4
                                                           length:[self.data length] - 4]];
    } else {
        return nil; // I'm not an image
    }
}

- (NSString *)asString
{
    if ([self isString]) { // UTF-8 String
        return [[NSString alloc]initWithBytes:[self.data bytes] + 4
                                       length:[self.data length] - 4
                                     encoding:NSUTF8StringEncoding];
    } else if ([self isInteger]) {
        NSInteger integer = [self asInteger];
        return ([[NSString alloc]initWithFormat:@"%ld", integer]);
    }
    return @"";
}

- (NSInteger)asInteger
{
    if ([self isInteger]) {
        switch ([self.data length] - 4) {
            case 1:
                return *(UInt8 *)([self.data bytes] + 4);
            case 2:
                return CFSwapInt16BigToHost(*(UInt16 *)([self.data bytes] + 4));
//            case 3:
            case 4:
                return CFSwapInt32BigToHost(*(UInt32 *)([self.data bytes] + 4));
            case 8:
                return CFSwapInt64BigToHost(*(UInt64 *)([self.data bytes] + 4));
            default:
                break;
        }
    }
    return 0;
}

@end
