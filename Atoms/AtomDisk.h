//
//  AtomDisk.h
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom_iTMF.h"

@interface AtomDisk : Atom_iTMF
{
    UInt16 _diskNumber;
    UInt16 _totalDisks;
}

@property (readonly) UInt16 diskNumber;
@property (readonly) UInt16 totalDisks;

@end
