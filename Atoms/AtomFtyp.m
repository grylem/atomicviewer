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

static dispatch_once_t pred;
static NSDictionary *ftypDict;

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
    return NSLocalizedStringFromTable(@"File Type",
                                      @"atomName",
                                      @"Atom ftyp name");
}

- (NSString *)ftypExplanationFromType:(NSString *)type
{
    dispatch_once (&pred, ^{
        ftypDict = @{
                     // List from http://ftyps.com/
                     @"3g2a" : NSLocalizedStringFromTable(@"3GPP2 Media (.3G2) compliant with 3GPP2 C.S0050-0 V1.0",
                                                          @"ftyp",
                                                          @"3g2a ftyp description"),
                     @"3g2b" : NSLocalizedStringFromTable(@"3GPP2 Media (.3G2) compliant with 3GPP2 C.S0050-A V1.0.0",
                                                          @"ftyp",
                                                          @"3g2b ftyp description"),
                     @"3g2c" : NSLocalizedStringFromTable(@"3GPP2 Media (.3G2) compliant with 3GPP2 C.S0050-B v1.0",
                                                          @"ftyp",
                                                          @"3g2c ftyp description"),
                     @"3ge6" : NSLocalizedStringFromTable(@"3GPP (.3GP) Release 6 MBMS Extended Presentations",
                                                          @"ftyp",
                                                          @"3ge6 ftyp description"),
                     @"3ge7" : NSLocalizedStringFromTable(@"3GPP (.3GP) Release 7 MBMS Extended Presentations",
                                                          @"ftyp",
                                                          @"3ge7 ftyp description"),
                     @"3gg6" : NSLocalizedStringFromTable(@"3GPP Release 6 General Profile",
                                                          @"ftyp",
                                                          @"3gg6 ftyp description"),
                     @"3gp1" : NSLocalizedStringFromTable(@"3GPP Media (.3GP) Release 1",
                                                          @"ftyp",
                                                          @"3gp1 ftyp description"),
                     @"3gp2" : NSLocalizedStringFromTable(@"3GPP Media (.3GP) Release 2",
                                                          @"ftyp",
                                                          @"3gp2 ftyp description"),
                     @"3gp3" : NSLocalizedStringFromTable(@"3GPP Media (.3GP) Release 3",
                                                          @"ftyp",
                                                          @"3gp3 ftyp description"),
                     @"3gp4" : NSLocalizedStringFromTable(@"3GPP Media (.3GP) Release 4",
                                                          @"ftyp",
                                                          @"3gp4 ftyp description"),
                     @"3gp5" : NSLocalizedStringFromTable(@"3GPP Media (.3GP) Release 5",
                                                          @"ftyp",
                                                          @"3gp5 ftyp description"),
                     @"3gp6" : NSLocalizedStringFromTable(@"3GPP Media (.3GP) Release 6 Basic Profile",
                                                          @"ftyp",
                                                          @"3gp6 ftyp description"),
                     @"3gs7" : NSLocalizedStringFromTable(@"3GPP Media (.3GP) Release 7 Streaming Servers",
                                                          @"ftyp",
                                                          @"3gs7 ftyp description"),
                     @"avc1" : NSLocalizedStringFromTable(@"MP4 Base w/ AVC ext [ISO 14496-12:2005]",
                                                          @"ftyp",
                                                          @"avc1 ftyp description"),
                     @"CAEP" : NSLocalizedStringFromTable(@"Canon Digital Camera",
                                                          @"ftyp",
                                                          @"CAEP ftyp description"),
                     @"caqv" : NSLocalizedStringFromTable(@"Casio Digital Camera",
                                                          @"ftyp",
                                                          @"caqv ftyp description"),
                     @"CDes" : NSLocalizedStringFromTable(@"Convergent Design",
                                                          @"ftyp",
                                                          @"CDes ftyp description"),
                     @"da0a" : NSLocalizedStringFromTable(@"DMB MAF w/ MPEG Layer II aud, MOT slides, DLS, JPG/PNG/MNG images",
                                                          @"ftyp",
                                                          @"da0a ftyp description"),
                     @"da0b" : NSLocalizedStringFromTable(@"DMB MAF, extending DA0A, with 3GPP timed text, DID, TVA, REL, IPMP",
                                                          @"ftyp",
                                                          @"da0b ftyp description"),
                     @"da1a" : NSLocalizedStringFromTable(@"DMB MAF audio with ER-BSAC audio, JPG/PNG/MNG images",
                                                          @"ftyp",
                                                          @"da1a ftyp description"),
                     @"da1b" : NSLocalizedStringFromTable(@"DMB MAF, extending da1a, with 3GPP timed text, DID, TVA, REL, IPMP",
                                                          @"ftyp",
                                                          @"da1b ftyp description"),
                     @"da2a" : NSLocalizedStringFromTable(@"DMB MAF aud w/ HE-AAC v2 aud, MOT slides, DLS, JPG/PNG/MNG images",
                                                          @"ftyp",
                                                          @"da2a ftyp description"),
                     @"da2b" : NSLocalizedStringFromTable(@"DMB MAF, extending da2a, with 3GPP timed text, DID, TVA, REL, IPMP",
                                                          @"ftyp",
                                                          @"da2b ftyp description"),
                     @"da3a" : NSLocalizedStringFromTable(@"DMB MAF aud with HE-AAC aud, JPG/PNG/MNG images",
                                                          @"ftyp",
                                                          @"da3a ftyp description"),
                     @"da3b" : NSLocalizedStringFromTable(@"DMB MAF, extending da3a w/ BIFS, 3GPP timed text, DID, TVA, REL, IPMP",
                                                          @"ftyp",
                                                          @"da3b ftyp description"),
                     @"dmb1" : NSLocalizedStringFromTable(@"DMB MAF supporting all the components defined in the specification",
                                                          @"ftyp",
                                                          @"dmb1 ftyp description"),
                     @"dmpf" : NSLocalizedStringFromTable(@"Digital Media Project",
                                                          @"ftyp",
                                                          @"dmpf ftyp description"),
                     @"drc1" : NSLocalizedStringFromTable(@"Dirac (wavelet compression), encapsulated in ISO base media (MP4)",
                                                          @"ftyp",
                                                          @"drc1 ftyp description"),
                     @"dv1a" : NSLocalizedStringFromTable(@"DMB MAF vid w/ AVC vid, ER-BSAC aud, BIFS, JPG/PNG/MNG images, TS",
                                                          @"ftyp",
                                                          @"dv1a ftyp description"),
                     @"dv1b" : NSLocalizedStringFromTable(@"DMB MAF, extending dv1a, with 3GPP timed text, DID, TVA, REL, IPMP",
                                                          @"ftyp",
                                                          @"dv1b ftyp description"),
                     @"dv2a" : NSLocalizedStringFromTable(@"DMB MAF vid w/ AVC vid, HE-AAC v2 aud, BIFS, JPG/PNG/MNG images, TS",
                                                          @"ftyp",
                                                          @"dv2a ftyp description"),
                     @"dv2b" : NSLocalizedStringFromTable(@"DMB MAF, extending dv2a, with 3GPP timed text, DID, TVA, REL, IPMP",
                                                          @"ftyp",
                                                          @"dv2b ftyp description"),
                     @"dv3a" : NSLocalizedStringFromTable(@"DMB MAF vid w/ AVC vid, HE-AAC aud, BIFS, JPG/PNG/MNG images, TS",
                                                          @"ftyp",
                                                          @"dv3a ftyp description"),
                     @"dv3b" : NSLocalizedStringFromTable(@"DMB MAF, extending dv3a, with 3GPP timed text, DID, TVA, REL, IPMP",
                                                          @"ftyp",
                                                          @"dv3b ftyp description"),
                     @"dvr1" : NSLocalizedStringFromTable(@"DVB (.DVB) over RTP",
                                                          @"ftyp",
                                                          @"dvr1 ftyp description"),
                     @"dvt1" : NSLocalizedStringFromTable(@"DVB (.DVB) over MPEG-2 Transport Stream",
                                                          @"ftyp",
                                                          @"dvt1 ftyp description"),
                     @"F4V " : NSLocalizedStringFromTable(@"Video for Adobe Flash Player 9+ (.F4V)",
                                                          @"ftyp",
                                                          @"F4V  ftyp description"),
                     @"F4P " : NSLocalizedStringFromTable(@"Protected Video for Adobe Flash Player 9+ (.F4P)",
                                                          @"ftyp",
                                                          @"F4P  ftyp description"),
                     @"F4A " : NSLocalizedStringFromTable(@"Audio for Adobe Flash Player 9+ (.F4A)",
                                                          @"ftyp",
                                                          @"F4A  ftyp description"),
                     @"F4B " : NSLocalizedStringFromTable(@"Audio Book for Adobe Flash Player 9+ (.F4B)",
                                                          @"ftyp",
                                                          @"F4B  ftyp description"),
                     @"isc2" : NSLocalizedStringFromTable(@"ISMACryp 2.0 Encrypted File",
                                                          @"ftyp",
                                                          @"isc2 ftyp description"),
                     @"iso2" : NSLocalizedStringFromTable(@"MP4 Base Media v2 [ISO 14496-12:2005]",
                                                          @"ftyp",
                                                          @"iso2 ftyp description"),
                     @"isom" : NSLocalizedStringFromTable(@"MP4  Base Media v1 [IS0 14496-12:2003]",
                                                          @"ftyp",
                                                          @"isom ftyp description"),
                     @"JP2 " : NSLocalizedStringFromTable(@"JPEG 2000 Image (.JP2) [ISO 15444-1 ?]",
                                                          @"ftyp",
                                                          @"JP2  ftyp description"),
                     @"JP20" : NSLocalizedStringFromTable(@"Unknown, from GPAC samples",
                                                          @"ftyp",
                                                          @"JP20 ftyp description"),
                     @"jpm " : NSLocalizedStringFromTable(@"JPEG 2000 Compound Image (.JPM) [ISO 15444-6]",
                                                          @"ftyp",
                                                          @"jpm  ftyp description"),
                     @"jpx " : NSLocalizedStringFromTable(@"JPEG 2000 w/ extensions (.JPX) [ISO 15444-2]",
                                                          @"ftyp",
                                                          @"jpx  ftyp description"),
                     @"KDDI" : NSLocalizedStringFromTable(@"3GPP2 EZmovie for KDDI 3G cellphones",
                                                          @"ftyp",
                                                          @"KDDI ftyp description"),
                     @"M4A " : NSLocalizedStringFromTable(@"Apple iTunes AAC-LC (.M4A) Audio",
                                                          @"ftyp",
                                                          @"M4A  ftyp description"),
                     @"M4B " : NSLocalizedStringFromTable(@"Apple iTunes AAC-LC (.M4B) Audio Book",
                                                          @"ftyp",
                                                          @"M4B ftyp description"),
                     @"M4P " : NSLocalizedStringFromTable(@"Apple iTunes AAC-LC (.M4P) AES Protected Audio",
                                                          @"ftyp",
                                                          @"M4P  ftyp description"),
                     @"M4V " : NSLocalizedStringFromTable(@"Apple iTunes Video (.M4V) Video",
                                                          @"ftyp",
                                                          @"M4V  ftyp description"),
                     @"M4VH" : NSLocalizedStringFromTable(@"Apple TV (.M4V)",
                                                          @"ftyp",
                                                          @"M4VH ftyp description"),
                     @"M4VP" : NSLocalizedStringFromTable(@"Apple iPhone (.M4V)",
                                                          @"ftyp",
                                                          @"M4VP ftyp description"),
                     @"mj2s" : NSLocalizedStringFromTable(@"Motion JPEG 2000 [ISO 15444-3] Simple Profile",
                                                          @"ftyp",
                                                          @"mj2s ftyp description"),
                     @"mjp2" : NSLocalizedStringFromTable(@"Motion JPEG 2000 [ISO 15444-3] General Profile",
                                                          @"ftyp",
                                                          @"mj2p ftyp description"),
                     @"mmp4" : NSLocalizedStringFromTable(@"MPEG-4/3GPP Mobile Profile (.MP4 / .3GP) (for NTT)",
                                                          @"ftyp",
                                                          @"mmp4 ftyp description"),
                     @"mp21" : NSLocalizedStringFromTable(@"MPEG-21 [ISO/IEC 21000-9]",
                                                          @"ftyp",
                                                          @"mp21 ftyp description"),
                     @"mp41" : NSLocalizedStringFromTable(@"MP4 v1 [ISO 14496-1:ch13]",
                                                          @"ftyp",
                                                          @"mp41 ftyp description"),
                     @"mp42" : NSLocalizedStringFromTable(@"MP4 v2 [ISO 14496-14]",
                                                          @"ftyp",
                                                          @"mp42 ftyp description"),
                     @"mp71" : NSLocalizedStringFromTable(@"MP4 w/ MPEG-7 Metadata [per ISO 14496-12]",
                                                          @"ftyp",
                                                          @"mp71 ftyp description"),
                     @"MPPI" : NSLocalizedStringFromTable(@"Photo Player, MAF [ISO/IEC 23000-3]",
                                                          @"ftyp",
                                                          @"MPPI ftyp description"),
                     @"mqt " : NSLocalizedStringFromTable(@"Sony / Mobile QuickTime (.MQV)  US Patent 7,477,830 (Sony Corp)",
                                                          @"ftyp",
                                                          @"mqt  ftyp description"),
                     @"MSNV" : NSLocalizedStringFromTable(@"MPEG-4 (.MP4) for SonyPSP",
                                                          @"ftyp",
                                                          @"MSNV ftyp description"),
                     @"NDAS" : NSLocalizedStringFromTable(@"MP4 v2 [ISO 14496-14] Nero Digital AAC Audio",
                                                          @"ftyp",
                                                          @"NDAS ftyp description"),
                     @"NDSC" : NSLocalizedStringFromTable(@"MPEG-4 (.MP4) Nero Cinema Profile",
                                                          @"ftyp",
                                                          @"NDSC ftyp description"),
                     @"NDSH" : NSLocalizedStringFromTable(@"MPEG-4 (.MP4) Nero HDTV Profile",
                                                          @"ftyp",
                                                          @"NDSH ftyp description"),
                     @"NDSM" : NSLocalizedStringFromTable(@"MPEG-4 (.MP4) Nero Mobile Profile",
                                                          @"ftyp",
                                                          @"NDSM ftyp description"),
                     @"NDSP" : NSLocalizedStringFromTable(@"MPEG-4 (.MP4) Nero Portable Profile",
                                                          @"ftyp",
                                                          @"NDSP ftyp description"),
                     @"NDSS" : NSLocalizedStringFromTable(@"MPEG-4 (.MP4) Nero Standard Profile",
                                                          @"ftyp",
                                                          @"NDSS ftyp description"),
                     @"NDXC" : NSLocalizedStringFromTable(@"H.264/MPEG-4 AVC (.MP4) Nero Cinema Profile",
                                                          @"ftyp",
                                                          @"NDXC ftyp description"),
                     @"NDXH" : NSLocalizedStringFromTable(@"H.264/MPEG-4 AVC (.MP4) Nero HDTV Profile",
                                                          @"ftyp",
                                                          @"NDXH ftyp description"),
                     @"NDXM" : NSLocalizedStringFromTable(@"H.264/MPEG-4 AVC (.MP4) Nero Mobile Profile",
                                                          @"ftyp",
                                                          @"NDXM ftyp description"),
                     @"NDXP" : NSLocalizedStringFromTable(@"H.264/MPEG-4 AVC (.MP4) Nero Portable Profile",
                                                          @"ftyp",
                                                          @"NDXP ftyp description"),
                     @"NDXS" : NSLocalizedStringFromTable(@"H.264/MPEG-4 AVC (.MP4) Nero Standard Profile",
                                                          @"ftyp",
                                                          @"NDXS ftyp description"),
                     @"odcf" : NSLocalizedStringFromTable(@"OMA DCF DRM Format 2.0 (OMA-TS-DRM-DCF-V2_0-20060303-A)",
                                                          @"ftyp",
                                                          @"odcf ftyp description"),
                     @"opf2" : NSLocalizedStringFromTable(@"OMA PDCF DRM Format 2.1 (OMA-TS-DRM-DCF-V2_1-20070724-C)",
                                                          @"ftyp",
                                                          @"opf2 ftyp description"),
                     @"opx2" : NSLocalizedStringFromTable(@"OMA PDCF DRM + XBS extensions (OMA-TS-DRM_XBS-V1_0-20070529-C)",
                                                          @"ftyp",
                                                          @"opx2 ftyp description"),
                     @"pana" : NSLocalizedStringFromTable(@"Panasonic Digital Camera",
                                                          @"ftyp",
                                                          @"pana ftyp description"),
                     @"qt  " : NSLocalizedStringFromTable(@"Apple QuickTime (.MOV/QT)",
                                                          @"ftyp",
                                                          @"qt   ftyp description"),
                     @"ROSS" : NSLocalizedStringFromTable(@"Ross Video",
                                                          @"ftyp",
                                                          @"ROSS ftyp description"),
                     @"sdv " : NSLocalizedStringFromTable(@"SD Memory Card Video",
                                                          @"ftyp",
                                                          @"sdv  ftyp description"),
                     @"ssc1" : NSLocalizedStringFromTable(@"Samsung stereoscopic, single stream",
                                                          @"ftyp",
                                                          @"ssc1 ftyp description"),
                     @"ssc2" : NSLocalizedStringFromTable(@"Samsung stereoscopic, dual stream",
                                                          @"ftyp",
                                                          @"ssc2 ftyp description"),
                     };
    });
    NSString *explanation = ftypDict[type];
    return explanation ? explanation : @"";
}

- (NSString *)html
{
    const ftyp *ftyp = [[self data] bytes];

    NSString *majorBrandString = [self stringFromFourCC:&ftyp->majorBrand encoding:NSISOLatin1StringEncoding];
    NSString *majorBrandExplanationString = [self ftypExplanationFromType:majorBrandString];
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
        minorBrandString = NSLocalizedString(@"There is no minor brand.",nil);
    } else {
        minorBrandString = [NSString stringWithFormat:@"%@ <b>%@</b>",
                            NSLocalizedString(@"The file type minor brand is",nil),
                            minorBrandString];
    }
    if ([compatibleBrandsArray count] == 0) {
        compatibleBrandsString = NSLocalizedString(@"There are no compatible brands",nil);
    } else {
        compatibleBrandsString = NSLocalizedString(@"The compatible brands are",nil);
        compatibleBrandsString = [compatibleBrandsString stringByAppendingString:@":<ul>"];
        for (NSString *string in compatibleBrandsArray) {
            compatibleBrandsString = [compatibleBrandsString stringByAppendingString:[NSString stringWithFormat:@"<li><b>%@</b></li>", string]];
        }
        compatibleBrandsString = [compatibleBrandsString stringByAppendingString:@"</ul>"];
    }

    NSString *html = [NSString stringWithFormat:@"<body>%@<span style=\"font-size: 14px\"><font face=\"AvenirNext-Medium\"><p><br>%@ <b>%@</b>.<br>%@<br>%@</p></span></body>",
                      NSLocalizedString(@"The file type atom allows the reader to determine if this is a type of file the reader understands. It identifies the specifications with which the file is compatible.",nil),
                      NSLocalizedString(@"The file type major brand is", nil),
                      majorBrandString,
                      minorBrandString,
                      compatibleBrandsString];

    return html;
}

@end
