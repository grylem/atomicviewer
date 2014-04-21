//
//  AtomRndu.m
//  AtomicViewer
//
//  Created by Jay O'Conor on 4/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomRndu.h"

@implementation AtomRndu

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"rndu");
}

//+(NSString *)atomName
//{
//    return (@"Track Aperture Mode Dimensions");
//}

@end
