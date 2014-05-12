//
//  AtomDinf.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomDinf.h"

@implementation AtomDinf

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"dinf");
}

- (NSString *)atomName
{
    return (@"Data Information");
}

@end
