//
//  AtomMeta.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomMeta.h"

@implementation AtomMeta

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"meta");
}

+(NSString *)atomName
{
    return (@"Metadata");
}

-(BOOL) isFullBox
{
    return YES;
}

@end
