//
//  AtomGeID.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomGeID.h"

@implementation AtomGeID

static dispatch_once_t pred;
static NSDictionary *genreDict;

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"geID");
}

- (NSString *)atomName
{
    return (@"Genre ID");
}

- (NSString *)html
{
    NSString *genreID;

    dispatch_once (&pred, ^{
        genreDict = @{
                      // Genre ID list from http://www.apple.com/itunes/affiliates/resources/documentation/genre-mapping.html
                      // Music
                      @2 : @"Blues",
                      @3 : @"Comedy",
                      @4 : @"Children’s Music",
                      @5 : @"Classical",
                      @6 : @"Country",
                      @7 : @"Electronic",
                      @8 : @"Holiday",
                      @9 : @"Opera",
                      @10 : @"Singer/Songwriter",
                      @11 : @"Jazz",
                      @12 : @"Latino",
                      @13 : @"New Age",
                      @14 : @"Pop",
                      @15 : @"R&B/Soul",
                      @16 : @"Soundtrack",
                      @17 : @"Dance",
                      @18 : @"Hip-Hop/Rap",
                      @19 : @"World",
                      @20 : @"Alternative",
                      @21 : @"Rock",
                      @22 : @"Christian & Gospel",
                      @23 : @"Vocal",
                      @24 : @"Reggae",
                      @25 : @"Easy Listening",
                      @27 : @"J-Pop",
                      @28 : @"Enka",
                      @29 : @"Anime",
                      @30 : @"Kayokyoku",
                      @50 : @"Fitness & Workout",
                      @51 : @"K-Pop",
                      @52 : @"Karaoke",
                      @53 : @"Instrumental",
                      @1122 : @"Brazilian",
                      // Music Videos
                      @1602 : @"Blues",
                      @1603 : @"Comedy",
                      @1604 : @"Children’s Music",
                      @1605 : @"Classical",
                      @1606 : @"Country",
                      @1607 : @"Electronic",
                      @1608 : @"Holiday",
                      @1609 : @"Opera",
                      @1610 : @"Singer/Songwriter",
                      @1611 : @"Jazz",
                      @1612 : @"Latino",
                      @1613 : @"New Age",
                      @1614 : @"Pop",
                      @1615 : @"R&B/Soul",
                      @1616 : @"Soundtrack",
                      @1617 : @"Dance",
                      @1618 : @"Hip-Hop/Rap",
                      @1619 : @"World",
                      @1620 : @"Alternative",
                      @1621 : @"Rock",
                      @1622 : @"Christian & Gospel",
                      @1623 : @"Vocal",
                      @1624 : @"Reggae",
                      @1625 : @"Easy Listening",
                      @1626 : @"Podcasts",
                      @1627 : @"J-Pop",
                      @1628 : @"Enka",
                      @1629 : @"Anime",
                      @1630 : @"Kayokyoku",
                      @1631 : @"Disney",
                      @1632 : @"French Pop",
                      @1633 : @"German Pop",
                      @1634 : @"German Folk",
                      // TV Shows
                      @4000 : @"Comedy",
                      @4001 : @"Drama",
                      @4002 : @"Animation",
                      @4003 : @"Action & Adventure",
                      @4004 : @"Classic",
                      @4005 : @"Kids",
                      @4006 : @"Nonfiction",
                      @4007 : @"Reality TV",
                      @4008 : @"Sci-Fi & Fantasy",
                      @4009 : @"Sports",
                      @4010 : @"Teens",
                      @4011 : @"Latino TV",
                      // Movies
                      @4401 : @"Action & Adventure",
                      @4402 : @"Anime",
                      @4403 : @"Classics",
                      @4404 : @"Comedy",
                      @4405 : @"Documentary",
                      @4406 : @"Drama",
                      @4407 : @"Foreign",
                      @4408 : @"Horror",
                      @4409 : @"Independent",
                      @4410 : @"Kids & Family",
                      @4411 : @"Musicals",
                      @4412 : @"Romance",
                      @4413 : @"Sci-Fi & Fantasy",
                      @4414 : @"Short Films",
                      @4415 : @"Special Interest",
                      @4416 : @"Thriller",
                      @4417 : @"Sports",
                      @4418 : @"Western",
                      @4419 : @"Urban",
                      @4420 : @"Holiday",
                      @4421 : @"Made for TV",
                      @4422 : @"Concert Films",
                      @4423 : @"Music Documentaries",
                      @4424 : @"Music Feature Films",
                      @4425 : @"Japanese Cinema",
                      @4426 : @"Jidaigeki",
                      @4427 : @"Tokusatsu",
                      @4428 : @"Korean Cinema",
                      // Music
                      @50000061 : @"Spoken Word",
                      @50000063 : @"Disney",
                      @50000064 : @"French Pop",
                      @50000066 : @"German Pop",
                      @50000068 : @"German Folk"
                      };
    });
    genreID = genreDict[@([self asInteger])];
    if (!genreID) {
        genreID = @"Unknown";
    }
    NSString *htmlHeader = @"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>";
    NSString *htmlTrailer = @"</p></span></body>";
    NSString *string = [htmlHeader stringByAppendingString:genreID];
    string = [string stringByAppendingString:htmlTrailer];
    return string;
}

@end
