//
//  AtomFtyp.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomFtyp.h"

typedef enum : off_t {
    size = 0,
    type = 4,
    majorBrand = 8,
    minorBrand = 12,
    compatibleBrands = 16
} offsets;

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

-(NSString *)majorBrand
{
    if (!_majorBrand) {
        _majorBrand = [NSString new];
        char majorBrandString[5];
        majorBrandString[4] = '\0';
        dispatch_fd_t fd = dispatch_io_get_descriptor(self.io_channel);
        lseek(fd, self.origin + majorBrand, SEEK_SET); // Seek right after size & type
        read(fd, &majorBrandString, 4);
        _majorBrand = [NSString stringWithCString:majorBrandString encoding:NSISOLatin1StringEncoding];
    }
    return _majorBrand;
}

-(NSString *)minorBrand
{
    if (!_minorBrand) {
        char minorBrandString[5];
        minorBrandString[4] = '\0';
        dispatch_fd_t fd = dispatch_io_get_descriptor(self.io_channel);
        lseek(fd, self.origin + minorBrand, SEEK_SET); // Seek right after size & type
        read(fd, &minorBrandString, 4);
        _minorBrand = [NSString stringWithCString:minorBrandString encoding:NSISOLatin1StringEncoding];
    }
    return _minorBrand;
}

- (NSArray *)compatibleBrands
{
    if (!_compatibleBrands) {
        char compatibleBrandString[5];
        compatibleBrandString[4] = '\0';
        dispatch_fd_t fd = dispatch_io_get_descriptor(self.io_channel);
        size_t compatibleBrandsLength = self.dataLength - compatibleBrands;
        unsigned long numCompatibleBrands = compatibleBrandsLength / 4;
        _compatibleBrands = [NSArray new];
        lseek(fd, self.origin + minorBrand, SEEK_SET); // Seek right after size & type
        read(fd, &compatibleBrandString, 4);
        NSString *brandString = [NSString stringWithCString:compatibleBrandString encoding:NSISOLatin1StringEncoding];
    }
    return _compatibleBrands;
}

- (NSAttributedString *)decodedExplanation
{

    NSString *majorBrandString = self.majorBrand;
    NSString *minorBrandString = self.minorBrand;
    NSArray *compatibleBrands = self.compatibleBrands;

    if ([minorBrandString length] == 0) {
        minorBrandString = @"There is no minor brand.";
    } else {
        minorBrandString = [NSString stringWithFormat:@"The file type minor brand is <b>%@</b>",minorBrandString];
    }
//    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>The file type major brand is <b>%@</b>.</p><ul><li>I am a <b>list</b> item!</li><li>I am a list item too!</li><li>I am a list item also!</li></ul></span></body>", majorBrandString, minorBrandString];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>The file type major brand is <b>%@</b>.<br>%@</p></span></body>", majorBrandString, minorBrandString];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithData: [html dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:nil error:nil];

/*
    NSFont* bodyFont = [NSFont fontWithName:@"AvenirNext-Medium" size:14.0];
    NSMutableAttributedString* testText = [[NSMutableAttributedString alloc] initWithString: @"\t•\tItem 1\n\t•\tItem 2\n\t•\tItem 3\n\t•\tItem 4\n"];
    NSMutableParagraphStyle* myStringParaStyle1 = [NSMutableParagraphStyle new];
    myStringParaStyle1.headIndent = 36.0;
    NSMutableArray* tabArray = [NSMutableArray new];
    [tabArray addObject:[[NSTextTab alloc]initWithType:NSLeftTabStopType location:11.0]];
    [tabArray addObject:[[NSTextTab alloc]initWithType:NSLeftTabStopType location:36.0]];
    myStringParaStyle1.tabStops = tabArray;
    [testText addAttribute:NSParagraphStyleAttributeName value:myStringParaStyle1 range:NSMakeRange(0, [testText length])];
    [testText addAttribute:NSFontAttributeName value:bodyFont range:NSMakeRange(0, [testText length])];

    [testText appendAttributedString: attrString];
    return testText;
*/
    return attrString;
}

@end
