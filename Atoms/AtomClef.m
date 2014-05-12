//
//  AtomClef.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/27/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomClef.h"

@implementation AtomClef

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"clef");
}

- (NSString *)atomName
{
    return (@"Track Clean Aperture Dimensions");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
