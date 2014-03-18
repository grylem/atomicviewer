//
//  AtomXid.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomXid.h"

@implementation AtomXid

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"xid ");
}

@end
