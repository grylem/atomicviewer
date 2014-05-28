//
//  AtomSdtp.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomSdtp.h"

@implementation AtomSdtp

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"sdtp");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Independent and Disposable Samples",
                                      @"atomName",
                                      @"Atom sdtp name");
}

-(BOOL)isFullBox
{
    return YES;
}

@end
