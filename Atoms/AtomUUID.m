//
//  AtomUUID.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/23/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomUUID.h"

@implementation AtomUUID

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"UUID");
}

- (NSString *)atomName
{
    return (@"UUID");
}

@end
