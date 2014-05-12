//
//  AtomTapt.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/27/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTapt.h"

@implementation AtomTapt

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"tapt");
}

- (NSString *)atomName
{
    return (@"Track Aperture Mode Dimensions");
}

@end
