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

+(NSString *)atomName
{
    return (@"File Type");
}

- (NSString *)html
{
    char majorBrandBytes[5];
    majorBrandBytes[4] = '\0';
    NSRange majorBrandRange = NSMakeRange(offsetof(struct ftyp, majorBrand), member_size(ftyp, majorBrand));
    [self.data getBytes:&majorBrandBytes range:majorBrandRange];
    NSString *majorBrandString = [NSString stringWithCString:majorBrandBytes encoding:NSISOLatin1StringEncoding];

    char minorBrandBytes[5];
    minorBrandBytes[4] = '\0';
    NSRange minorBrandRange = NSMakeRange(offsetof(struct ftyp, minorBrand), member_size(ftyp, minorBrand));
    [self.data getBytes:&minorBrandBytes range:minorBrandRange];
    NSString *minorBrandString = [NSString stringWithCString:minorBrandBytes encoding:NSISOLatin1StringEncoding];

    char compatibleBrandString[5];
    compatibleBrandString[4] = '\0';
    size_t compatibleBrandsLength = self.dataLength - offsetof(struct ftyp, compatibleBrands);
    NSRange compatibleBrandsRange = NSMakeRange(offsetof(struct ftyp, compatibleBrands), 4);
    unsigned long numCompatibleBrands = compatibleBrandsLength / 4;

    NSMutableArray *__compatibleBrands = [NSMutableArray new];

    for (int i=0; i<numCompatibleBrands; i++) {
        [self.data getBytes:&compatibleBrandString range:compatibleBrandsRange];
        memcpy(&compatibleBrandString, [self.data bytes] + offsetof(struct ftyp, compatibleBrands) + (i * 4), 4);
        NSString *brandString = [NSString stringWithCString:compatibleBrandString
                                                   encoding:NSISOLatin1StringEncoding];
        if ([brandString length]) {
            [__compatibleBrands addObject: brandString];
        }
    }

    NSString *compatibleBrandsString;

    if ([minorBrandString length] == 0) {
        minorBrandString = @"There is no minor brand.";
    } else {
        minorBrandString = [NSString stringWithFormat:@"The file type minor brand is <b>%@</b>",minorBrandString];
    }
    if ([__compatibleBrands count] == 0) {
        compatibleBrandsString = @"There are no compatible brands";
    } else {
        compatibleBrandsString = @"The compatible brands are:<ul>";
        for (NSString *string in __compatibleBrands) {
            compatibleBrandsString = [compatibleBrandsString stringByAppendingString:[NSString stringWithFormat:@"<li><b>%@</b></li>", string]];
        }
        compatibleBrandsString = [compatibleBrandsString stringByAppendingString:@"</ul>"];
    }

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>The file type major brand is <b>%@</b>.<br>%@<br>%@</p></span></body>", majorBrandString, minorBrandString, compatibleBrandsString];

    return html;
}

@end
