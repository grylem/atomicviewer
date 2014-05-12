//
//  AtomUuidLC.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/27/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomUuidLC.h"

@implementation AtomUuidLC

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"uuid");
}

- (NSString *)atomName
{
    return (@"uuid");
}

@end
