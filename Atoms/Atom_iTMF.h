//
//  AtomSimpleiTunesMetadata.h
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 4/8/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomParent.h"

@interface Atom_iTMF : AtomParent

- (NSAttributedString *)decodedAsBoolean;
- (UInt16)getUInt16ValueAtOffset:(off_t)offset;
- (NSInteger)asInteger;
- (NSString *)asString;
- (NSAttributedString *)decodedExplanation;
- (NSData *)data;

@end
