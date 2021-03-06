//
//  AtomHdlr.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/16/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomHdlr.h"

#pragma pack(push,1)
typedef struct hdlr
{
    uint32_t component_type;        // = 0 for MPEG, non-zero for QT
    uint32_t component_subtype;
    uint32_t component_mfgr;        // = 0 (both QT & MPEG define this as zero. May be non-zero for QT)
    uint32_t component_flags;       // = 0 (both QT & MPEG define this as zero. May be non-zero for QT)
    uint32_t compoent_flags_mask;   // = 0 (both QT & MPEG define this as zero. May be non-zero for QT)
    uint8_t  component_name;        // null terminated UTF-8 strong for MPEG, counted (Pascal) string for QT
} hdlr;
#pragma pack(pop)

@implementation AtomHdlr

static dispatch_once_t pred;
static NSDictionary *subtypeDict;

+(void)load
{
    [self populateAtomToClassDict];
}

+(NSString *)atomType
{
    return (@"hdlr");
}

- (NSString *)atomName
{
    return NSLocalizedStringFromTable(@"Handler Reference",
                                      @"atomName",
                                      @"Atom hdlr name");
}

-(BOOL)isFullBox
{
    return YES;
}

- (NSString *)componentType
{
    const hdlr *hdlr_addr = [[self data] bytes];
    return [self stringFromFourCC:&hdlr_addr->component_type];
}

- (NSString *)componentSubtype
{
    const hdlr *hdlr_addr = [[self data] bytes];
    return [self stringFromFourCC:&hdlr_addr->component_subtype];
}

- (NSString *)componentMfgr
{
    const hdlr *hdlr_addr = [[self data] bytes];
    return [self stringFromFourCC:&hdlr_addr->component_mfgr];
}

- (NSString *)componentName
{
    NSString *component_name;

//  If componentType is set, then this is a Quicktime style hdlr atom, and we can expect the component name string to be a Pascal style (counted) string.
//  If componentType is not set, then this is an MPEG-4 style hdlr atom, and we can expect the component name string to be a C style (null terminated) string.
    if ([[self componentType] length] != 0) {
        const char *strlen_addr;
        strlen_addr = [[self data] bytes] + offsetof(hdlr, component_name);
        uint8_t string_length = *strlen_addr;
        component_name = [[NSString alloc] initWithBytes:(++strlen_addr)
                                                  length:string_length
                                                encoding:NSUTF8StringEncoding];
    } else {
        component_name = [[NSString alloc] initWithUTF8String:[[self data] bytes] + offsetof(hdlr, component_name)];
    }
    return component_name;
}

- (NSString *)typeExplanation
{
    NSString *type_explanation;
    if ([[self componentType] isEqualToString:@"mhlr"]) {
        type_explanation = NSLocalizedString(@"Media Handler",nil);
    } else if ([[self componentType] isEqualToString:@"dhlr"]) {
        type_explanation = NSLocalizedString(@"Data Handler",nil);
    } else {
        type_explanation = NSLocalizedString(@"Unrecongized Handler",nil);
    }
    return type_explanation;
}

- (NSString *)subtypeExplanation
{
    NSString *subtype_explanation;

    dispatch_once (&pred, ^{
        subtypeDict = @{
                        @"vide" : NSLocalizedString(@"Video",nil),
                        @"soun" : NSLocalizedString(@"Sound",nil),
                        @"tmcd" : NSLocalizedString(@"Timecode",nil),
                        @"alis" : NSLocalizedString(@"Alias",nil),
                        @"text" : NSLocalizedString(@"Text",nil),
                        @"clcp" : NSLocalizedString(@"Closed Captioning",nil),
                        @"sbtl" : NSLocalizedString(@"Subtitle",nil),
                        @"musi" : NSLocalizedString(@"Music",nil),
                        @"MPEG" : NSLocalizedString(@"MPEG-1",nil),
                        @"sprt" : NSLocalizedString(@"Sprite",nil),
                        @"twen" : NSLocalizedString(@"Tween",nil),
                        @"hint" : NSLocalizedString(@"Hint",nil),
                        @"mdta" : NSLocalizedString(@"Metadata",nil),
                        @"mdir" : NSLocalizedString(@"iTunes Metadata",nil),
                        };
    });
    subtype_explanation = subtypeDict[[self componentSubtype]];
    if (!subtype_explanation) {
        subtype_explanation = NSLocalizedString(@"Unrecongnized",nil);
    }
    return subtype_explanation;
}

- (NSString *)html
{
    NSString *html = @"<body><span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p>";

    if ([[self componentType] length] != 0) { // If Quicktime format hdlr atom
        NSString *tmpString = [NSString stringWithFormat:@"%@: <b>%@</b> (%@)<br>",
                               NSLocalizedString(@"Component Type",nil),
                               [self componentType],
                               [self typeExplanation]];
        html = [html stringByAppendingString:tmpString];
    }

    NSString *tmpString = [NSString stringWithFormat:@"%@: <b>%@</b> (%@)<br>",
                           NSLocalizedString(@"Component Subtype",nil),
                           [self componentSubtype],
                           [self subtypeExplanation]];
    html = [html stringByAppendingString:tmpString];

    if ([[self componentName] length] != 0) {
        tmpString = [NSString stringWithFormat:@"%@: <b>%@</b>",
                     NSLocalizedString(@"Component Name",nil),
                     [self componentName]];
        html = [html stringByAppendingString:tmpString];
    }
    html = [html stringByAppendingString:@"</p></span></body>"];

    return html;
}
@end
