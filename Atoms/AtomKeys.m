//
//  AtomKeys.m
//  AtomicViewer
//
//  Created by Jay O'Conor on 5/13/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomKeys.h"

@implementation AtomKeys

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"keys");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Metadata Item Keys",
                                      @"atomName",
                                      @"Atom keys name");
}

-(BOOL)isFullBox
{
    return YES;
}

-(NSUInteger) jump
{
    // keys atoms have a four byte "entry count" before the children atoms
    return 4;
}

@end
