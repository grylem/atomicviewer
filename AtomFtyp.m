//
//  AtomFtyp.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomFtyp.h"

@implementation AtomFtyp

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"ftyp");
}

+(NSString *)atomName
{
    return (@"File Type");
}

@end
