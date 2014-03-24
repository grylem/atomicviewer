//
//  AtomParent.h
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom.h"

@interface AtomParent : Atom
{
    dispatch_once_t childrenPred;
    NSMutableArray *children;
}
@end
