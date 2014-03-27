//
//  AtomDualState.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomDualState.h"
#import "AtomParent.h"

@implementation AtomDualState

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
    if ([_children count] == 0) {
        off_t childrenOffset = 8; // Just past size & type;
        if (self.extendedLength) {
            childrenOffset += 8; // Bump past extend length field
        }
        if (self.isFullBox) {
            childrenOffset += 4; // Bump past flags & version field
        }
        childrenOffset += self.jump; // skip over data
        [Atom populateOutline: _children
               fromFileHandle: self.fileHandle
                     atOffset: self.origin + childrenOffset
                         upTo: self.origin + self.dataLength];
    }
    return _children;
}

@end
