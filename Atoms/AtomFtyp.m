//
//  AtomFtyp.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomFtyp.h"

#define member_size(type, member) sizeof(((type *)0)->member)

#pragma pack(push,1)
typedef struct ftyp {
    uint32_t majorBrand;
    uint32_t minorBrand;
    uint32_t compatibleBrands[];
} ftyp;
#pragma pack(pop)

@implementation AtomFtyp

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"ftyp");
}

- (NSString *)atomName
{
    return (@"File Type");
}

- (NSString *)html
{
    const ftyp *ftyp = [[self data] bytes];

    NSString *majorBrandString = [self stringFromFourCC:&ftyp->majorBrand encoding:NSISOLatin1StringEncoding];
    NSString *minorBrandString = [self stringFromFourCC:&ftyp->minorBrand];

    size_t compatibleBrandsLength = self.dataLength - offsetof(struct ftyp, compatibleBrands);
    unsigned long numCompatibleBrands = compatibleBrandsLength / 4;

    NSMutableArray *compatibleBrandsArray = [NSMutableArray new];

    for (int i=0; i<numCompatibleBrands; i++) {
        NSString *brandString = [self stringFromFourCC:&ftyp->compatibleBrands[i] encoding:NSISOLatin1StringEncoding];
        if ([brandString length]) {
            [compatibleBrandsArray addObject: brandString];
        }
    }

    NSString *compatibleBrandsString;

    if ([minorBrandString length] == 0) {
        minorBrandString = @"There is no minor brand.";
    } else {
        minorBrandString = [NSString stringWithFormat:@"The file type minor brand is <b>%@</b>",minorBrandString];
    }
    if ([compatibleBrandsArray count] == 0) {
        compatibleBrandsString = @"There are no compatible brands";
    } else {
        compatibleBrandsString = @"The compatible brands are:<ul>";
        for (NSString *string in compatibleBrandsArray) {
            compatibleBrandsString = [compatibleBrandsString stringByAppendingString:[NSString stringWithFormat:@"<li><b>%@</b></li>", string]];
        }
        compatibleBrandsString = [compatibleBrandsString stringByAppendingString:@"</ul>"];
    }

    NSString *html = [NSString stringWithFormat:@"<body>The file type atom allows the reader to determine if this is a type of file the reader understands. It identifies the specifications with which the file is compatible.<span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p><br>The file type major brand is <b>%@</b>.<br>%@<br>%@</p></span></body>", majorBrandString, minorBrandString, compatibleBrandsString];

    return html;
}

@end
