//
//  AtomUnrecognized.h
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/15/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom.h"

@interface AtomUnrecognized : Atom

-initWithType: (NSString *)atomType length: (size_t)atomLength dataOffset: (off_t)offset isExtended: (BOOL)isExtendedLength usingChannel: (dispatch_io_t)channel onQueue: (dispatch_queue_t)queue inTree: (NSTreeController *)treeController;

@end

