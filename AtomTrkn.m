//
//  AtomTrkn.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTrkn.h"

@implementation AtomTrkn

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"trkn");
}

+(NSString *)atomName
{
    return (@"Track Number");
}

@end
