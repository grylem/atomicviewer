//
//  AtomHdlr.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomHdlr.h"

@implementation AtomHdlr

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"hdlr");
}

@end
