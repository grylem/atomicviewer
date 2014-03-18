//
//  AtomDualState.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomDualState.h"

@implementation AtomDualState
{
    dispatch_once_t childrenPred;
}

-(NSUInteger) jump
{
    return jump;
}

-(void) setJump: (NSUInteger) jumpValue
{
    jump = jumpValue;
}

-(BOOL) isLeaf
{
    // We expect a concrete subclass to have a non-zero jump value. If that hasn't happened, then treat this like a child (leaf) atom.
    return [self jump] == 0;
}

-(NSMutableArray *) children
{
    
    // Here's where I need to populate the array
    // This just initiates populating the children array.
    // The array is not populated when this function returns.
    // "return children" most likely returns an empty array
    
    dispatch_once(&childrenPred, ^{
        off_t childrenOffset = 8; // Just past size & type;
        if (self.extendedLength) {
            childrenOffset += 8; // Bump past extend length field
        }
        if (self.isFullBox) {
            childrenOffset += 4; // Bump past flags & version field
        }
        childrenOffset += self.jump; // skip over data
        children = [NSMutableArray new];
        [Atom populateTree: self.treeController childOf: [self indexPath] atIndex: 0 fromChannel: self.io_channel onQueue: self.queue atOffset: self.origin + childrenOffset upTo: self.origin + self.dataLength];
    });
    return children;
}

@end
