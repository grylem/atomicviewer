//
//  AtomCatg.m
//  AtomicViewer
//
//  Created by Jay O'Conor on 4/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomCatg.h"

@implementation AtomCatg

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"catg");
}

//+(NSString *)atomName
//{
//    return (@"Track Aperture Mode Dimensions");
//}

@end
