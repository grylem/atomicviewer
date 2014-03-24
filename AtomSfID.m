//
//  AtomSfID.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomSfID.h"

@implementation AtomSfID

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"sfID");
}

+(NSString *)atomName
{
    return (@"Storefront ID");
}

@end
