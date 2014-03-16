//
//  AtomUnrecognized.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/15/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomUnrecognized.h"

@interface AtomUnrecognized ()
@property NSString *type;
@end

@implementation AtomUnrecognized

-initWithType: (NSString *)atomType length: (size_t)atomLength dataOffset: (off_t)offset usingChannel: (dispatch_io_t)channel onQueue: (dispatch_queue_t)queue
{
    if (self = [super initWithLength:atomLength dataOffset:offset usingChannel:channel onQueue:queue]) {
        
        self.type = atomType;
    }
    
    return self;
}

-(NSString *)nodeTitle
{
    return self.type;
}

@end
