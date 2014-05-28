//
//  AtomGnre.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/24/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomGnre.h"

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

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Genre",
                                      @"atomName",
                                      @"Atom gnre name");
}

- (NSString *)html
{

    UInt16 integer = [self getUInt16ValueAtOffset:4];
    NSString *genre;

    dispatch_once (&pred, ^{
        genreDict = @{
                      // Genre mapping from http://id3.org/id3v2.4.0-frames Appendix A
                      @1  : NSLocalizedStringFromTable(@"Blues",
                                                       @"gnre",
                                                       @"Genre 0 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @2  : NSLocalizedStringFromTable(@"Classic Rock",
                                                       @"gnre",
                                                       @"Genre 1 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @3  : NSLocalizedStringFromTable(@"Country",
                                                       @"gnre",
                                                       @"Genre 2 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @4  : NSLocalizedStringFromTable(@"Dance",
                                                       @"gnre",
                                                       @"Genre 3 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @5  : NSLocalizedStringFromTable(@"Disco",
                                                       @"gnre",
                                                       @"Genre 4 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @6  : NSLocalizedStringFromTable(@"Funk",
                                                       @"gnre",
                                                       @"Genre 5 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @7  : NSLocalizedStringFromTable(@"Grunge",
                                                       @"gnre",
                                                       @"Genre 6 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @8  : NSLocalizedStringFromTable(@"Hip-Hop",
                                                       @"gnre",
                                                       @"Genre 7 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @9  : NSLocalizedStringFromTable(@"Jazz",
                                                       @"gnre",
                                                       @"Genre 8 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @10 : NSLocalizedStringFromTable(@"Metal",
                                                       @"gnre",
                                                       @"Genre 9 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @11 : NSLocalizedStringFromTable(@"New Age",
                                                       @"gnre",
                                                       @"Genre 10 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @12 : NSLocalizedStringFromTable(@"Oldies",
                                                       @"gnre",
                                                       @"Genre 11 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @13 : NSLocalizedStringFromTable(@"Other",
                                                       @"gnre",
                                                       @"Genre 12 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @14 : NSLocalizedStringFromTable(@"Pop",
                                                       @"gnre",
                                                       @"Genre 13 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @15 : NSLocalizedStringFromTable(@"R&B",
                                                       @"gnre",
                                                       @"Genre 14 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @16 : NSLocalizedStringFromTable(@"Rap",
                                                       @"gnre",
                                                       @"Genre 15 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @17 : NSLocalizedStringFromTable(@"Reggae",
                                                       @"gnre",
                                                       @"Genre 16 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @18 : NSLocalizedStringFromTable(@"Rock",
                                                       @"gnre",
                                                       @"Genre 17 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @19 : NSLocalizedStringFromTable(@"Techno",
                                                       @"gnre",
                                                       @"Genre 18 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @20 : NSLocalizedStringFromTable(@"Industrial",
                                                       @"gnre",
                                                       @"Genre 19 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @21 : NSLocalizedStringFromTable(@"Alternative",
                                                       @"gnre",
                                                       @"Genre 20 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @22 : NSLocalizedStringFromTable(@"Ska",
                                                       @"gnre",
                                                       @"Genre 21 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @23 : NSLocalizedStringFromTable(@"Death Metal",
                                                       @"gnre",
                                                       @"Genre 22 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @24 : NSLocalizedStringFromTable(@"Pranks",
                                                       @"gnre",
                                                       @"Genre 23 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @25 : NSLocalizedStringFromTable(@"Soundtrack",
                                                       @"gnre",
                                                       @"Genre 24 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @26 : NSLocalizedStringFromTable(@"Euro-Techno",
                                                       @"gnre",
                                                       @"Genre 25 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @27 : NSLocalizedStringFromTable(@"Ambient",
                                                       @"gnre",
                                                       @"Genre 26 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @28 : NSLocalizedStringFromTable(@"Trip-Hop",
                                                       @"gnre",
                                                       @"Genre 27 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @29 : NSLocalizedStringFromTable(@"Vocal",
                                                       @"gnre",
                                                       @"Genre 28 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @30 : NSLocalizedStringFromTable(@"Jazz+Funk",
                                                       @"gnre",
                                                       @"Genre 29 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @31 : NSLocalizedStringFromTable(@"Fusion",
                                                       @"gnre",
                                                       @"Genre 30 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @32 : NSLocalizedStringFromTable(@"Trance",
                                                       @"gnre",
                                                       @"Genre 31 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @33 : NSLocalizedStringFromTable(@"Classical",
                                                       @"gnre",
                                                       @"Genre 32 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @34 : NSLocalizedStringFromTable(@"Instrumental",
                                                       @"gnre",
                                                       @"Genre 33 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @35 : NSLocalizedStringFromTable(@"Acid",
                                                       @"gnre",
                                                       @"Genre 34 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @36 : NSLocalizedStringFromTable(@"House",
                                                       @"gnre",
                                                       @"Genre 35 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @37 : NSLocalizedStringFromTable(@"Game",
                                                       @"gnre",
                                                       @"Genre 36 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @38 : NSLocalizedStringFromTable(@"Sound Clip",
                                                       @"gnre",
                                                       @"Genre 37 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @39 : NSLocalizedStringFromTable(@"Gospel",
                                                       @"gnre",
                                                       @"Genre 38 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @40 : NSLocalizedStringFromTable(@"Noise",
                                                       @"gnre",
                                                       @"Genre 39 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @41 : NSLocalizedStringFromTable(@"AlternRock",
                                                       @"gnre",
                                                       @"Genre 40 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @42 : NSLocalizedStringFromTable(@"Bass",
                                                       @"gnre",
                                                       @"Genre 41 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @43 : NSLocalizedStringFromTable(@"Soul",
                                                       @"gnre",
                                                       @"Genre 42 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @44 : NSLocalizedStringFromTable(@"Punk",
                                                       @"gnre",
                                                       @"Genre 43 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @45 : NSLocalizedStringFromTable(@"Space",
                                                       @"gnre",
                                                       @"Genre 44 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @46 : NSLocalizedStringFromTable(@"Meditative",
                                                       @"gnre",
                                                       @"Genre 45 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @47 : NSLocalizedStringFromTable(@"Instrumental Pop",
                                                       @"gnre",
                                                       @"Genre 46 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @48 : NSLocalizedStringFromTable(@"Instrumental Rock",
                                                       @"gnre",
                                                       @"Genre 47 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @49 : NSLocalizedStringFromTable(@"Ethnic",
                                                       @"gnre",
                                                       @"Genre 48 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @50 : NSLocalizedStringFromTable(@"Gothic",
                                                       @"gnre",
                                                       @"Genre 49 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @51 : NSLocalizedStringFromTable(@"Darkwave",
                                                       @"gnre",
                                                       @"Genre 50 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @52 : NSLocalizedStringFromTable(@"Techno-Industrial",
                                                       @"gnre",
                                                       @"Genre 51 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @53 : NSLocalizedStringFromTable(@"Electronic",
                                                       @"gnre",
                                                       @"Genre 52 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @54 : NSLocalizedStringFromTable(@"Pop-Folk",
                                                       @"gnre",
                                                       @"Genre 53 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @55 : NSLocalizedStringFromTable(@"Eurodance",
                                                       @"gnre",
                                                       @"Genre 54 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @56 : NSLocalizedStringFromTable(@"Dream",
                                                       @"gnre",
                                                       @"Genre 55 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @57 : NSLocalizedStringFromTable(@"Southern Rock",
                                                       @"gnre",
                                                       @"Genre 56 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @58 : NSLocalizedStringFromTable(@"Comedy",
                                                       @"gnre",
                                                       @"Genre 57 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @59 : NSLocalizedStringFromTable(@"Cult",
                                                       @"gnre",
                                                       @"Genre 58 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @60 : NSLocalizedStringFromTable(@"Gangsta",
                                                       @"gnre",
                                                       @"Genre 59 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @61 : NSLocalizedStringFromTable(@"Top 40",
                                                       @"gnre",
                                                       @"Genre 60 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @62 : NSLocalizedStringFromTable(@"Christian Rap",
                                                       @"gnre",
                                                       @"Genre 61 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @63 : NSLocalizedStringFromTable(@"Pop/Funk",
                                                       @"gnre",
                                                       @"Genre 62 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @64 : NSLocalizedStringFromTable(@"Jungle",
                                                       @"gnre",
                                                       @"Genre 63 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @65 : NSLocalizedStringFromTable(@"Native American",
                                                       @"gnre",
                                                       @"Genre 64 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @66 : NSLocalizedStringFromTable(@"Cabaret",
                                                       @"gnre",
                                                       @"Genre 65 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @67 : NSLocalizedStringFromTable(@"New Wave",
                                                       @"gnre",
                                                       @"Genre 66 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @68 : NSLocalizedStringFromTable(@"Psychadelic",
                                                       @"gnre",
                                                       @"Genre 67 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @69 : NSLocalizedStringFromTable(@"Rave",
                                                       @"gnre",
                                                       @"Genre 68 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @70 : NSLocalizedStringFromTable(@"Showtunes",
                                                       @"gnre",
                                                       @"Genre 69 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @71 : NSLocalizedStringFromTable(@"Trailer",
                                                       @"gnre",
                                                       @"Genre 70 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @72 : NSLocalizedStringFromTable(@"Lo-Fi",
                                                       @"gnre",
                                                       @"Genre 71 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @73 : NSLocalizedStringFromTable(@"Tribal",
                                                       @"gnre",
                                                       @"Genre 72 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @74 : NSLocalizedStringFromTable(@"Acid Punk",
                                                       @"gnre",
                                                       @"Genre 73 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @75 : NSLocalizedStringFromTable(@"Acid Jazz",
                                                       @"gnre",
                                                       @"Genre 74 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @76 : NSLocalizedStringFromTable(@"Polka",
                                                       @"gnre",
                                                       @"Genre 75 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @77 : NSLocalizedStringFromTable(@"Retro",
                                                       @"gnre",
                                                       @"Genre 76 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @78 : NSLocalizedStringFromTable(@"Musical",
                                                       @"gnre",
                                                       @"Genre 77 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @79 : NSLocalizedStringFromTable(@"Rock & Roll",
                                                       @"gnre",
                                                       @"Genre 78 from http://id3.org/id3v2.4.0-frames Appendix A"),
                      @80 : NSLocalizedStringFromTable(@"Hard Rock",
                                                       @"gnre",
                                                       @"Genre 79 from http://id3.org/id3v2.4.0-frames Appendix A")
                      };
    });
    genre = genreDict[@(integer)];
    if (!genre) {
        genre = NSLocalizedString(@"Unknown Genre",
                                  @"String to use when gnre value doesn't map to http://id3.org/id3v2.4.0-frames Appendix A");
    }
    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      %@\
                      </p></span></body>",
                      genre];
    return html;
}

@end
