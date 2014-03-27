//
//  AtomUnrecognized.h
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/15/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom.h"

@interface AtomUnrecognized : Atom

-initWithType: (NSString *)atomType length: (size_t)atomLength dataOffset: (off_t)offset isExtended: (BOOL)isExtendedLength usingFileHandle: (NSFileHandle *)fileHandle;

@end

