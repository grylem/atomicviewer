//
//  Atom©cmt.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom©cmt.h"

@implementation Atom_cmt

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"©cmt");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Comment",
                                      @"atomName",
                                      @"Atom ©cmt name");
}

-(BOOL) isLeaf
{
    return ![self isiTunesMetadata];
}

- (NSString *)html
{
    if ([self isiTunesMetadata]) {
        return [super html];
    }
    return @"";
}

@end
