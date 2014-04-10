//
//  AtomGnre.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/24/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomGnre.h"
#import "AtomData.h"

@implementation AtomGnre

static dispatch_once_t pred;
static NSDictionary *genreDict;

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"gnre");
}

+(NSString *)atomName
{
    return (@"Genre");
}

- (NSAttributedString *)decodedExplanation
{
    // We can't use [dataAtom asInteger] here, as the data atom
    // doesn't encode itself as an integer "well-known" type.
    // Flags will be zero, indicating we must explicitly hande
    // interpreting the data.
    // We know that the data will be a two-byte integer value.

    AtomData *dataAtom = (AtomData *)[self findChildAtomOfType: @"data"];
    [dataAtom.fileHandle seekToFileOffset:dataAtom.origin + 16];
    NSData *integerData = [dataAtom.fileHandle readDataOfLength:2];
    UInt16 integer = CFSwapInt16BigToHost(*(UInt16 *)[integerData bytes]);
    NSString *genre;

    dispatch_once (&pred, ^{
        genreDict = @{
                      // Genre mapping from http://id3.org/id3v2.4.0-frames Appendix A
                      @1  : @"Blues",
                      @2  : @"Classic Rock",
                      @3  : @"Country",
                      @4  : @"Dance",
                      @5  : @"Disco",
                      @6  : @"Funk",
                      @7  : @"Grunge",
                      @8  : @"Hip-Hop",
                      @9  : @"Jazz",
                      @10 : @"Metal",
                      @11 : @"New Age",
                      @12 : @"Oldies",
                      @13 : @"Other",
                      @14 : @"Pop",
                      @15 : @"R&B",
                      @16 : @"Rap",
                      @17 : @"Reggae",
                      @18 : @"Rock",
                      @19 : @"Techno",
                      @20 : @"Industrial",
                      @21 : @"Alternative",
                      @22 : @"Ska",
                      @23 : @"Death Metal",
                      @24 : @"Pranks",
                      @25 : @"Soundtrack",
                      @26 : @"Euro-Techno",
                      @27 : @"Ambient",
                      @28 : @"Trip-Hop",
                      @29 : @"Vocal",
                      @30 : @"Jazz+Funk",
                      @31 : @"Fusion",
                      @32 : @"Trance",
                      @33 : @"Classical",
                      @34 : @"Instrumental",
                      @35 : @"Acid",
                      @36 : @"House",
                      @37 : @"Game",
                      @38 : @"Sound Clip",
                      @39 : @"Gospel",
                      @40 : @"Noise",
                      @41 : @"AlternRock",
                      @42 : @"Bass",
                      @43 : @"Soul",
                      @44 : @"Punk",
                      @45 : @"Space",
                      @46 : @"Meditative",
                      @47 : @"Instrumental Pop",
                      @48 : @"Instrumental Rock",
                      @49 : @"Ethnic",
                      @50 : @"Gothic",
                      @51 : @"Darkwave",
                      @52 : @"Techno-Industrial",
                      @53 : @"Electronic",
                      @54 : @"Pop-Folk",
                      @55 : @"Eurodance",
                      @56 : @"Dream",
                      @57 : @"Southern Rock",
                      @58 : @"Comedy",
                      @59 : @"Cult",
                      @60 : @"Gangsta",
                      @61 : @"Top 40",
                      @62 : @"Christian Rap",
                      @63 : @"Pop/Funk",
                      @64 : @"Jungle",
                      @65 : @"Native American",
                      @66 : @"Cabaret",
                      @67 : @"New Wave",
                      @68 : @"Psychadelic",
                      @69 : @"Rave",
                      @70 : @"Showtunes",
                      @71 : @"Trailer",
                      @72 : @"Lo-Fi",
                      @73 : @"Tribal",
                      @74 : @"Acid Punk",
                      @75 : @"Acid Jazz",
                      @76 : @"Polka",
                      @77 : @"Retro",
                      @78 : @"Musical",
                      @79 : @"Rock & Roll",
                      @80 : @"Hard Rock"
                      };
    });
    genre = genreDict[@(integer)];
    if (!genre) {
        genre = @"Unknown";
    }
    return [[NSAttributedString alloc] initWithString: genre];
}

@end
