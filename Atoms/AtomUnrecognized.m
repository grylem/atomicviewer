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

-initWithType: (NSString *)atomType
       length: (size_t)atomLength
   dataOffset: (off_t)offset
   isExtended: (BOOL)isExtendedLength
usingFileHandle: (NSFileHandle *)fileHandle
{
    if (self = [super initWithLength: atomLength
                          dataOffset: offset
                          isExtended: isExtendedLength
                     usingFileHandle: fileHandle
                          withParent: nil]) {

        self.type = atomType;
    }

    return self;
}

-(NSString *)atomType
{
    return self.type;
}

@end
