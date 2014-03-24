//
//  AtomDualState.h
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

// Dual State atoms are both child & parent. There is (usually?) data at the beginning of the atom, followed by the children atoms.
// This abstract superclass has the basic behavior for skipping over the data so we can parse the children.

#import "AtomParent.h"

@interface AtomDualState : AtomParent
{
    NSUInteger jump;
}
@end
