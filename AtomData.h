//
//  AtomData.h
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom.h"

@interface AtomData : Atom

- (BOOL)isImage;
- (BOOL)isInteger;

- (NSString *)asString;
- (NSImage *)asImage;

@end
