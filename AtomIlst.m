//
//  AtomIlst.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomIlst.h"

@implementation AtomIlst

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"ilst");
}

+(NSString *)atomName
{
    return (@"Metadata Item List");
}

@end
