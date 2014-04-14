//
//  AtomAkID.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/24/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomAkID.h"
#import "AtomData.h"

@implementation AtomAkID

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"akID");
}

+(NSString *)atomName
{
    return (@"iTunes Store Account Type");
}

- (NSAttributedString *)decodedExplanation
{
    AtomData *dataAtom = (AtomData *)[self findChildAtomOfType: @"data"];
    NSInteger integer = [dataAtom asInteger];
    NSString *accountType;

    switch (integer) {
        case 0:
            accountType = @"iTunes";
            break;
        case 1:
            accountType = @"AOL";
            break;
        default:
            accountType = @"Unknown";
            break;
    };
    return [[NSAttributedString alloc] initWithString: accountType];
}

@end
