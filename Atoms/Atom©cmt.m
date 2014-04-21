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

+(NSString *)atomName
{
    return (@"Comment");
}

-(BOOL) isLeaf
{
    return ![self isiTunesMetadata];
}

- (NSAttributedString *)decodedExplanation
{
    if ([self isiTunesMetadata]) {
        return [super decodedExplanation];
    }
    return [[NSAttributedString alloc] initWithString:@""];
}

@end
