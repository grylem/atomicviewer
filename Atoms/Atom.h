//
//  Atom.h
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Atom : NSObject
@property off_t origin;
@property size_t length;
@property (readonly) BOOL isLeaf;
@property BOOL isExtendedLength;
@property (weak) Atom *parent;
@property NSUInteger version;
@property NSUInteger flags;
@property (nonatomic) NSData *data;
@property (readonly) NSArray *children;

#pragma mark - Class cluster mapping

+ (void)populateAtomToClassDict;

#pragma mark - Class methods

+ (Atom *)createRootWithFileHandle: (NSFileHandle *)fileHandle ofSize: (size_t)fileSize;
+ (NSString *)stringFromFourCC: (const void *)fourCCPtr encoding: (NSStringEncoding) encoding;

#pragma mark - Instance methods

- (instancetype) initWithLength: (size_t)atomLength dataOffset: (off_t)offset isExtended: (BOOL)isExtendedLength usingFileHandle: (NSFileHandle *)fileHandle withParent: (Atom *)parent;
- (void) populateArray: (NSMutableArray *)array fromOffset: (off_t)myOffset;
- (NSString *)atomType;
- (NSString *)atomName;
- (BOOL) isFullBox;
- (NSString *)nodeTitle;
- (NSUInteger)nodeOrigin;
- (NSUInteger)nodeLength;
- (NSUInteger)nodeEnd;
- (NSAttributedString *)explanation;
- (NSString *)asString;
- (NSString *)html;
- (off_t)dataOffset;
- (size_t)dataLength;

#pragma mark - Atom searching

- (BOOL)isDescendantOf:(NSString *)atomHierarchyString;
- (BOOL)isImmediateDescendantOf:(NSString *)expectedParentAtomType;
- (Atom *)findChildAtomOfType: (NSString *)typeString;
- (Atom *)findAtomAtPath:(NSString *)atomPath;

#pragma mark - Behavior to support iTunes Metadata

- (BOOL)hasImage;
- (NSImage *)image;
- (BOOL)isiTunesMetadata;

#pragma mark - Data access

- (UInt16)getUInt16ValueAtOffset:(off_t)offset;
- (UInt32)getUInt32ValueAtOffset:(off_t)offset;
- (uint32_t)get1616ValueAtOffset: (off_t)offset hi: (uint16_t*)hi lo: (uint16_t*)lo;
- (uint16_t)get88ValueAtOffset: (off_t)offset hi: (uint8_t*)hi lo: (uint8_t*)lo;
- (uint32_t)get230ValueAtOffset: (off_t)offset hi: (uint8_t*)hi lo: (uint32_t*)lo;
- (NSDate*)getUInt32TimeValueAtOffset: (off_t)offset;
- (uint32_t)getUInt32DurationValueAtOffset: (off_t)offset usingTimescale: (uint32_t)timescale hours: (uint16_t*)hours minutes: (uint16*)minutes seconds: (double*)seconds;
- (NSString *)stringFromFourCC: (const void *)fourCCPtr encoding: (NSStringEncoding)encoding;
- (NSString *)stringFromFourCC: (const void *)fourCCPtr;

@end
