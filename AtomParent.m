//
//  AtomParent.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

// Abstract superclass for all atoms that are able to be parent (non-leaf) containers
// Subclasses that may or may not be parents still should inherit from this class,
// but need to override -isLeaf if the specific instance is not a parent.

#import "AtomParent.h"

@implementation AtomParent

-(BOOL) isLeaf
{
    return NO;
}

// Here's where I need to populate the children array
// This just initiates populating the array.
// The array will be populated asynchronously
// "return children" most likely returns an empty array.
-(NSMutableArray *) children
{
    dispatch_once(&childrenPred, ^{
        children = [NSMutableArray new];
        off_t childrenOffset = 8; // Right after size & type
        if (self.extendedLength) {
            childrenOffset += 8; // Bump it past the extended length field
        }
        if (self.isFullBox) {
            childrenOffset += 4; // Bump it past the flags & version field
        }
        [Atom populateTree: self.treeController childOf: [self indexPath] atIndex: 0 fromChannel: self.io_channel onQueue: self.queue atOffset: self.origin + childrenOffset upTo: self.origin + self.dataLength];
    });
    return children;
}

@end
