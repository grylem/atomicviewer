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
- (UInt16)getUInt16ValueAtOffset:(off_t)offset;

@end
