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
@property dispatch_io_t io_channel;
@property dispatch_queue_t queue;
@property BOOL isLeaf;
@property NSTreeController *treeController;
@property NSIndexPath *indexPath;
@property BOOL extendedLength;

+ (void)populateAtomToClassDict;
+ (NSString *)atomType;
+ (void)populateTree: (NSTreeController *)treeController childOf:(NSIndexPath *)indexPath atIndex:(NSInteger)index fromChannel: (dispatch_io_t)channel onQueue: (dispatch_queue_t)queue atOffset: (off_t)offset upTo: (off_t)end;
-(instancetype) initWithLength: (size_t)atomLength dataOffset: (off_t)offset isExtended: (BOOL)isExtendedLength usingChannel: (dispatch_io_t)channel onQueue: (dispatch_queue_t)queue inTree: (NSTreeController *)treeController;
-(BOOL) isFullBox;

@end
