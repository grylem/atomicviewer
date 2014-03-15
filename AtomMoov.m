//
//  AtomMoov.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMoov.h"

@implementation AtomMoov

// This is the string we want in the outline.
-(NSString *)nodeTitle
{
    return (@"moov");
}

-(BOOL) isLeaf
{
    return NO;
}

-(NSMutableArray *) children
{
    // Here's where I need to populate the array
    
    [Atom populateContents: children fromChannel: self.io_channel onQueue: self.queue atOffset: self.fileOffset upTo: self.fileOffset + self.dataLength];

    // This doesn't work. populateContents:fromChannel:onQueue:atOffset:upTo: runs asynchronously.
    // The children array isn't ready yet.
    return children;
}

-(instancetype) initWithLength: (size_t)atomLength dataOffset: (off_t)offset usingChannel: (dispatch_io_t)channel onQueue: (dispatch_queue_t)queue;
{
    self = [super initWithLength:atomLength dataOffset:offset usingChannel:channel onQueue:queue];
    if (self) {
        children = [NSMutableArray new];
    }
    return self;
}



@end
