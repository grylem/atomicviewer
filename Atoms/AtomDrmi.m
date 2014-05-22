//
//  AtomDrmi.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/24/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomDrmi.h"

@implementation AtomDrmi

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"drmi");
}

- (NSString *)atomName
{
    return (@"FairPlay Protected Video");
}

-(BOOL)isFullBox
{
    return YES;
}

-(NSUInteger) jump
{
    // not sure what this is (yet)
    return 74;
}

@end
