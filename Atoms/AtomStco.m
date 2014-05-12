//
//  AtomStco.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomStco.h"

@implementation AtomStco

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"stco");
}

- (NSString *)atomName
{
    return (@"Chunk Offset");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
