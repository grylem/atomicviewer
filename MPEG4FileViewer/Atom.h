//
//  Atom.h
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Atom : NSObject
@property size_t dataLength;
@property off_t origin;
@property (readonly) BOOL isLeaf;
@property NSTreeController *treeController;
@property NSIndexPath *indexPath;
@property BOOL extendedLength;
@property NSFileHandle *fileHandle;

+ (void)populateAtomToClassDict;
+ (NSString *)atomType;
+ (void)populateOutline: (NSMutableArray *)contents fromFileHandle: fileHandle atOffset: (off_t)offset upTo: (off_t)end;

-(instancetype) initWithLength: (size_t)atomLength dataOffset: (off_t)offset isExtended: (BOOL)isExtendedLength usingFileHandle: (NSFileHandle *)fileHandle;
-(BOOL) isFullBox;
-(NSAttributedString *)explanation;
-(NSString *)atomName;
-(NSString *)atomType;
-(NSString *)nodeTitle;
-(NSUInteger)nodeOrigin;
-(NSUInteger)nodeLength;
-(NSUInteger)nodeEnd;

@end
