//
//  AtomRoot.m
//  AtomicViewer
//
//  Created by Jay O'Conor on 5/6/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomRoot.h"

@implementation AtomRoot

-(NSArray *) children
{
    if ([_children count] == 0) {
        [self populateArray: _children fromOffset: 0 ];
    }
    return _children;
}

@end
