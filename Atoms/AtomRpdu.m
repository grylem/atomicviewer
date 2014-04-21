//
//  AtomRpdu.m
//  AtomicViewer
//
//  Created by Jay O'Conor on 4/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomRpdu.h"

@implementation AtomRpdu

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"rpdu");
}

//+(NSString *)atomName
//{
//    return (@"Track Aperture Mode Dimensions");
//}

@end
