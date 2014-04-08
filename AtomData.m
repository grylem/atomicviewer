//
//  AtomData.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomData.h"

@implementation AtomData

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"data");
}

-(BOOL)isFullBox
{
    return YES;
}


-(NSString *)atomName
{
    if ([self isiTunesMetadata]) {
        NSString *parentName = self.parent.atomName;
        return [@"Data for parent " stringByAppendingFormat:@"%@ atom", parentName];
    } else {
        return [super atomName];
    }
}

// Only data for "covr" atom has an image

// Refactor this?
// Perhaps "covr" should ask its "data" for the image?
// This would allow covr to iterate over multiple data atoms
// and allow the data atom to validate the "well-known" data type.

-(BOOL)hasImage
{
    if ([self isiTunesMetadata]) {
        return self.parent.hasImage;
    } else {
        return [super hasImage];
    }
}

-(NSImage *)image
{
    if ([self isiTunesMetadata]) {
        return self.parent.image;
    } else {
        return [super image];
    }
}
@end
