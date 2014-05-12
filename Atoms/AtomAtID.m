//
//  AtomAtID.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomAtID.h"

@implementation AtomAtID

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"atID");
}

- (NSString *)atomName
{
    return (@"Album Title ID");
}

@end
