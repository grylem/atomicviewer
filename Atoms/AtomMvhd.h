//
//  AtomMvhd.h
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom.h"

@interface AtomMvhd : Atom

- (uint32_t)timescale;

@end
