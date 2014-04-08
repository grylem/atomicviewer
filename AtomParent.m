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

-(instancetype) initWithLength: (size_t)atomLength
                    dataOffset: (off_t)offset
                    isExtended: (BOOL)isExtendedLength
               usingFileHandle: (NSFileHandle *)fileHandle
                    withParent: (Atom *)parent
{
    self = [super initWithLength: atomLength
                      dataOffset: offset
                      isExtended: isExtendedLength
                 usingFileHandle: fileHandle
                      withParent: parent];
    if (self) {
        _children = [NSMutableArray array];
    }
    return self;
}

-(BOOL) isLeaf
{
    return NO;
}

-(NSUInteger) jump
{
    return 0;
}

-(NSArray *) children
{
    if ([_children count] == 0) {
        off_t childrenOffset = 8;
        if (self.extendedLength) {
            childrenOffset += 8;
        }
        if (self.isFullBox) {
            childrenOffset += 4;
        }
        childrenOffset += self.jump; // skip over data
        [Atom populateOutline: _children
               fromFileHandle: self.fileHandle
                     atOffset: self.origin + childrenOffset         // maybe just pass self & childrenOffset to a new method?
                         upTo: self.origin + self.dataLength
                    asChildOf: self];
    }
    return _children;
}

#pragma mark - Child atom searching

-(Atom *)findChildAtomOfType:(NSString *)typeString
{
    for (Atom *atom in self.children) {
        if ([[atom atomType]  isEqual: typeString]) {
            return atom;
        }
    }
    return nil;
}

@end
