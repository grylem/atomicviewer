//
//  AtomStik.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomStik.h"
#import "AtomData.h"

@implementation AtomStik

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"stik");
}

+(NSString *)atomName
{
    return (@"Media Kind");
}

- (NSAttributedString *)decodedExplanation
{
    AtomData *dataAtom = (AtomData *)[self findChildAtomOfType: @"data"];
    NSInteger integer = [dataAtom asInteger];
    NSString *mediaType;

    switch (integer) {
        case 0:
            mediaType = @"Movie";
            break;
        case 1:
            mediaType = @"Music";
        case 2:
            mediaType = @"Audiobook";
            break;
        case 6:
            mediaType = @"Music Video";
            break;
        case 9:
            mediaType = @"Movie";
            break;
        case 10:
            mediaType = @"TV Show";
            break;
        case 11:
            mediaType = @"Booklet";
            break;
        case 14:
            mediaType = @"Ringtone";
            break;
        default:
            mediaType = @"Unknown";
            break;
    };
    return [[NSAttributedString alloc] initWithString: mediaType];
}

@end
