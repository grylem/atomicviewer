//
//  AtomPadb.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/20/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomPadb.h"

@implementation AtomPadb

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"padb");
}

- (NSString *)atomName
{
    return (@"Padding Bits");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
