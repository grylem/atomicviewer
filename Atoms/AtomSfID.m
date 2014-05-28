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

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Storefront ID",
                                      @"atomName",
                                      @"Atom sfID name");
}

- (NSString *)html
{
    NSArray *storefrontID;

    dispatch_once (&pred, ^{
        storefrontDict = @{
                           @143460 : @[@"AUS", NSLocalizedString(@"Australia",@"iTunes Storefront Country")],
                           @143445 : @[@"AUT", NSLocalizedString(@"Austria",@"iTunes Storefront Country")],
                           @143446 : @[@"BEL", NSLocalizedString(@"Belgium",@"iTunes Storefront Country")],
                           @143455 : @[@"CAN", NSLocalizedString(@"Canada",@"iTunes Storefront Country")],
                           @143458 : @[@"DNK", NSLocalizedString(@"Denmark",@"iTunes Storefront Country")],
                           @143447 : @[@"FIN", NSLocalizedString(@"Finland",@"iTunes Storefront Country")],
                           @143442 : @[@"FRA", NSLocalizedString(@"France",@"iTunes Storefront Country")],
                           @143443 : @[@"DEU", NSLocalizedString(@"Germany",@"iTunes Storefront Country")],
                           @143448 : @[@"GRC", NSLocalizedString(@"Greece",@"iTunes Storefront Country")],
                           @143449 : @[@"IRL", NSLocalizedString(@"Ireland",@"iTunes Storefront Country")],
                           @143450 : @[@"ITA", NSLocalizedString(@"Italy",@"iTunes Storefront Country")],
                           @143462 : @[@"JPN", NSLocalizedString(@"Japan",@"iTunes Storefront Country")],
                           @143451 : @[@"LUX", NSLocalizedString(@"Luxembourg",@"iTunes Storefront Country")],
                           @143452 : @[@"NLD", NSLocalizedString(@"Netherlands",@"iTunes Storefront Country")],
                           @143461 : @[@"NZL", NSLocalizedString(@"New Zealand",@"iTunes Storefront Country")],
                           @143457 : @[@"NOR", NSLocalizedString(@"Norway",@"iTunes Storefront Country")],
                           @143453 : @[@"PRT", NSLocalizedString(@"Portugal",@"iTunes Storefront Country")],
                           @143454 : @[@"ESP", NSLocalizedString(@"Spain",@"iTunes Storefront Country")],
                           @143456 : @[@"SWE", NSLocalizedString(@"Sweden",@"iTunes Storefront Country")],
                           @143459 : @[@"CHE", NSLocalizedString(@"Switzerland",@"iTunes Storefront Country")],
                           @143444 : @[@"GBR", NSLocalizedString(@"United Kingdom",@"iTunes Storefront Country")],
                           @143441 : @[@"USA", NSLocalizedString(@"United States",@"iTunes Storefront Country")]
                           };
    });
    storefrontID = storefrontDict[@([self asInteger])];
    NSString *storefrontString = storefrontID ? storefrontID[1] : NSLocalizedString(@"Unknown Storefront ID",@"iTunes Storefront Country");
    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>%@</p></span></body>",
                      storefrontString];
    return html;
}

@end
