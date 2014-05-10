//
//  AtomSfID.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomSfID.h"

@implementation AtomSfID

static dispatch_once_t pred;
static NSDictionary *storefrontDict;

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"sfID");
}

+(NSString *)atomName
{
    return (@"Storefront ID");
}

- (NSString *)html
{
    NSArray *storefrontID;

    dispatch_once (&pred, ^{
        storefrontDict = @{
                           @143460 : @[@"AUS", @"Australia"],
                           @143445 : @[@"AUT", @"Austria"],
                           @143446 : @[@"BEL", @"Belgium"],
                           @143455 : @[@"CAN", @"Canada"],
                           @143458 : @[@"DNK", @"Denmark"],
                           @143447 : @[@"FIN", @"Finland"],
                           @143442 : @[@"FRA", @"France"],
                           @143443 : @[@"DEU", @"Germany"],
                           @143448 : @[@"GRC", @"Greece"],
                           @143449 : @[@"IRL", @"Ireland"],
                           @143450 : @[@"ITA", @"Italy"],
                           @143462 : @[@"JPN", @"Japan"],
                           @143451 : @[@"LUX", @"Luxembourg"],
                           @143452 : @[@"NLD", @"Netherlands"],
                           @143461 : @[@"NZL", @"New Zealand"],
                           @143457 : @[@"NOR", @"Norway"],
                           @143453 : @[@"PRT", @"Portugal"],
                           @143454 : @[@"ESP", @"Spain"],
                           @143456 : @[@"SWE", @"Sweden"],
                           @143459 : @[@"CHE", @"Switzerland"],
                           @143444 : @[@"GBR", @"United Kingdom"],
                           @143441 : @[@"USA", @"United States"]
                           };
    });
    storefrontID = storefrontDict[@([self asInteger])];
    NSString *storefrontString = storefrontID ? storefrontID[1] : @"Unknown";
    NSString *htmlHeader = @"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>";
    NSString *htmlTrailer = @"</p></span></body>";
    NSString *string = [htmlHeader stringByAppendingString:storefrontString];
    string = [string stringByAppendingString:htmlTrailer];
    return string;
}

@end
