//
//  AtomStsd.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/17/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomStsd.h"

@implementation AtomStsd

#pragma pack(push,1)
typedef struct stsd
{
    uint32_t entry_count;
}stsd;
#pragma pack(pop)

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"stsd");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Sample Description",
                                      @"atomName",
                                      @"Atom stsd name");
}

-(BOOL)isFullBox
{
    return YES;
}

-(NSUInteger) jump
{
    return sizeof(stsd);
}

- (NSString *)html
{
    const struct stsd *stsd = [[self data] bytes];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      <br>%@: <b>%u</b>\
                      </p></span></body>",
                      NSLocalizedString(@"Number of Sample Descriptions",nil),
                      CFSwapInt32BigToHost(stsd->entry_count)];
    return html;
}

@end
