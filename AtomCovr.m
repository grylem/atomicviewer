//
//  AtomCovr.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomCovr.h"

@implementation AtomCovr

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"covr");
}

+(NSString *)atomName
{
    return (@"Cover Art");
}

-(NSString *)atomName
{
    NSImage *image = [self image];
    return [[self class] atomName];
}
-(NSImage *)image
{
    Atom *dataAtom = [self findChildAtomOfType: @"data"];
    // We read the atom data here, as we're the ones who know
    // the correct format of the atom contents
    [dataAtom.fileHandle seekToFileOffset: dataAtom.origin + 16];
    NSImage *image = [[NSImage alloc] initWithData:[dataAtom.fileHandle readDataOfLength:dataAtom.dataLength - 16]];
    return image;
}

@end
