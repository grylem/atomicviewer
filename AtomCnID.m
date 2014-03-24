//
//  AtomCnID.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomCnID.h"

@implementation AtomCnID

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"cnID");
}

+(NSString *)atomName
{
    return (@"Apple Store Catalog ID");
}

@end
