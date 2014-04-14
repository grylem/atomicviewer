//
//  AtomCprt.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

// The cprt atom is defined by ISO/IEC 14496-12,
// but is used differently in iTunes metadata.
// We need to check the context of the cprt atom
// before interpreting its contents.

#import "AtomCprt.h"
#import "AtomData.h"

@implementation AtomCprt

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"cprt");
}

+(NSString *)atomName
{
    return (@"Copyright");
}

//  This is the formatted textual explantion of the content of the atom
- (NSAttributedString *)decodedExplanation
{
    if (self.isiTunesMetadata) {
        AtomData *dataAtom = (AtomData *)[self findChildAtomOfType: @"data"];
        NSString *string = [dataAtom asString];
        return [[NSAttributedString alloc] initWithString: string];
    } else {
        return [[NSAttributedString alloc] initWithString: @"Copyright outside iTunes metadata context"];
    }
}

@end
