//
//  AtomParent.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

// Abstract superclass for all atoms that are able to be parent (non-leaf) containers
// Subclasses that may or may not be parents still should inherit from us, but need to override -isLeaf

#import "AtomParent.h"

@implementation AtomParent
{
    dispatch_once_t childrenPred;
}

-(BOOL) isLeaf
{
    return NO;
}

-(NSMutableArray *) children
{
    
    // Here's where I need to populate the array
    // This just initiates populating the children array.
    // The array is not populated when this function returns.
    // "return children" most likely returns an empty array
    
    dispatch_once(&childrenPred, ^{
        children = [NSMutableArray new];
        [Atom populateTree: self.treeController childOf: [self indexPath] atIndex: 0 fromChannel: self.io_channel onQueue: self.queue atOffset: self.fileOffset upTo: self.fileOffset + self.dataLength];
    });
    return children;
}

@end
