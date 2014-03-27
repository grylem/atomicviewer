//
//  AtomFtyp.h
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom.h"

@interface AtomFtyp : Atom
{
    NSString *_majorBrand;
    NSString *_minorBrand;
    NSArray *_compatibleBrands;
}

@property (readonly) NSString *majorBrand;
@property (readonly) NSString *minorBrand;
@property (readonly) NSMutableArray  *compatibleBrands;

@end
