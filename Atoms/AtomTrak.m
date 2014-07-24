//
//  AtomTrak.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomTrak.h"

#import "AtomTkhd.h"

@implementation AtomTrak

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"trak");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Track",
                                      @"atomName",
                                      @"Atom trak name");
}

-(NSString *)nodeTitle
{
    return [NSString stringWithFormat:@"trak [%@]", @([self trakNumber])];
}

-(AtomTkhd *)trakHeader
{
    NSUInteger trakHeaderIndex = [self.children indexOfObjectPassingTest:^BOOL (id object, NSUInteger idx, BOOL *stop){return [object isKindOfClass:[AtomTkhd class]];}];
    return (self.children)[trakHeaderIndex];
}

-(NSUInteger)trakNumber
{
    return [[self trakHeader] trakNumber];
}
@end
