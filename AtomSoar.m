//
//  AtomSoar.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/24/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomSoar.h"

@implementation AtomSoar

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"soar");
}

@end
