//
//  Atom----.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom----.h"

@implementation Atom____

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"----");
}

- (NSString *)atomName
{
    return @"Reverse DNS Style iTunes Metadata";
}

- (BOOL)isRating
{
    Atom *atom = [self findChildAtomOfType:@"name"];
    if ([[atom asString] isEqualToString: @"iTunEXTC"]) {
        return YES;
    }
    return NO;
}

- (NSString *)html
{
    NSArray *ratingsLabels = @[@"Rating Organization: ", @"Rating: ", @"Rating Value: ", @"Rating Explanation: "];
    NSString *html = @"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>";

    if ([self isRating]) {
        Atom *atom = [self findChildAtomOfType:@"data"];
        NSString *string = [atom asString];
        NSArray *ratingsArray = [string componentsSeparatedByString:@"|"];

        int i = 0;
        for (NSString *ratingString in ratingsArray) {
            if ([ratingString length] > 0) {
                html = [html stringByAppendingString:[NSString stringWithFormat:@"%@<b>%@</b><br>",
                        ratingsLabels[i],
                        ratingString]];
            }
            i++;
        }
    }
    html = [html stringByAppendingString:@"</p></span></body>"];
    return html;
}

@end
