//
//  AtomHdvd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomHdvd.h"
#import "AtomData.h"

@implementation AtomHdvd

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"hdvd");
}

+(NSString *)atomName
{
    return (@"HD Video");
}

- (NSAttributedString *)decodedExplanation
{
    AtomData *dataAtom = (AtomData *)[self findChildAtomOfType: @"data"];
    NSInteger integer = [dataAtom asInteger];
    NSString *resolutionType;

    switch (integer) {
        case 0:
            resolutionType = @"SD Video";
            break;
        case 1:
            resolutionType = @"HD Video: 720p";
            break;
        default:
            resolutionType = @"HD Video: 1080p";
            break;
    };
    return [[NSAttributedString alloc] initWithString: resolutionType];
}

@end
