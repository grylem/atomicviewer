//
//  AtomTrkn.h
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom_iTMF.h"

@interface AtomTrkn : Atom_iTMF
{
    UInt16 _trackNumber;
    UInt16 _totalTracks;
}

@property (readonly) UInt16 trackNumber;
@property (readonly) UInt16 totalTracks;

@end
