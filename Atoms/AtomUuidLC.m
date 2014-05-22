//
//  AtomUuidLC.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/27/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomUuidLC.h"

@implementation AtomUuidLC

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"uuid");
}

- (NSString *)atomName
{
    return (@"uuid");
}

- (NSString *)html
{
    const unsigned char *uuid_addr = [[self data] bytes];
    NSUUID *uuid;

    uuid = [[NSUUID alloc] initWithUUIDBytes:uuid_addr];

    NSString *html = [NSString stringWithFormat:@"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>\
                      UUID: <b>%@</b><br>\
                      </p></span></body>",
                      [uuid UUIDString]];
    return html;

}
@end
