//
//  Atom©nam.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom©nam.h"

@implementation Atom_nam

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"©nam");
}

- (NSString *)atomName
{
    return (@"Title of the Content");
}

@end
