//
//  AtomStz2.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomStz2.h"

@implementation AtomStz2

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"stz2");
}

- (NSString *)atomName
{
    return (@"Compact Sample Size");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
