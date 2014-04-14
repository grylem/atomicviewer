//
//  AtomProf.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/27/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomProf.h"

@implementation AtomProf

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"prof");
}

+(NSString *)atomName
{
    return (@"Track Production Aperture Dimensions");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
