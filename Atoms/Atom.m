//
//  Atom.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "Atom.h"
#import "AtomUnrecognized.h"
#import "AtomRoot.h"

@interface Atom ()
@property NSFileHandle *fileHandle;
@end

@implementation Atom

static NSMutableDictionary *atomToClassDict;
static dispatch_once_t pred;

#pragma mark - Class cluster mapping

// HERE BE MONSTERS
// My subclasses invoke this during their +load. BE CAREFUL
// This is ONLY for subclasses to populate the atom type to Class dictionary.
// Do not use for any other purpose, as heavy lifting during +load is EXTREMELY dangerous.
// Note, +initialize cannot be used, as +initialize is invoked lazily before first message sent to the class
// If we don't have the Class in the atomToClassDict, it'll never get messages, so +initilize will never be invoked.
+ (void)populateAtomToClassDict
{
    dispatch_once (&pred, ^{
        atomToClassDict = [NSMutableDictionary new];
    });
    
    if (self != [Atom class]) {
        [atomToClassDict setValue: [self class] forKey:[self atomType]];
    }
}

#pragma mark - Class methods

+ (Atom *)createRootWithFileHandle: (NSFileHandle *)fileHandle
                            ofSize: (size_t)fileSize
{
    Atom *root = [[AtomRoot alloc] initWithLength: fileSize
                                       dataOffset: 0
                                       isExtended: NO
                                  usingFileHandle: fileHandle
                                       withParent: nil];
    return root;
}

//  Convenience method to create a new atom.
//  Atoms are a class cluster, so this method looks up the real class in the atomToClassDict and creates an instance of the class found there. An instance of AtomUnrecognized is created if the atom type is not found in atomToClassDict.
//  The new instance is initialized with:
//  • The 4-character atomType
//  • The real length of the entire atom (including length & type fields)
//  • The offset within the file where this atom is located
//  • A flag indicating if this atom uses a 32-bit or 64-bit length field
//  • The dispatch_io channel used for reading atom contents
//  • The GCD queue on which asynchronous reads should occur
//  • The tree controller controlling the outline in which this atom will be stored

+ (Atom *)createAtomOfType: (NSString *)atomType
                withLength: (size_t)atomLength
                fromOffset: (off_t)offset
                isExtended: (BOOL)isExtendedLength
                withParent: (Atom *)parent
{
    Class atomClass = atomToClassDict[atomType];
    Atom *newAtom;

    if (atomClass) {
        newAtom = [[atomClass alloc] initWithLength: atomLength
                                         dataOffset: offset
                                         isExtended: isExtendedLength
                                    usingFileHandle: parent.fileHandle
                                         withParent: parent];
    } else {
        newAtom = [[AtomUnrecognized alloc] initWithType: atomType
                                                  length: atomLength
                                              dataOffset: offset
                                              isExtended: isExtendedLength
                                         usingFileHandle: parent.fileHandle];
    }
    return newAtom;
}

//  This is the primary means of creating atoms.
//  This will create all the atoms at a specific level in the atom hierarchy

+ (void)populateArray: (NSMutableArray *)contents
       fromFileHandle: (NSFileHandle *)fileHandle
             atOffset: (off_t)offset
                 upTo: (off_t)end
            asChildOf: (Atom *)parent
{
    size_t actualSize;
    BOOL isExtendedLength = NO;
    NSString *atomTypeString;
    Atom *atom;

    [fileHandle seekToFileOffset: offset];
    NSData *fileData = [fileHandle readDataOfLength:8];

    // We've read 8 bytes: length & atom type
    // byteswap the length & copy the atom type to a C string
    uint32_t size = CFSwapInt32BigToHost (*(uint32_t *)[fileData bytes]);
    actualSize = size;

    // If extended length, read next 8 bytes to get the real atom length
    if (size == 1) {
        isExtendedLength = YES;

        // Read the extended length synchronously
        [fileHandle seekToFileOffset: offset + 8];

        NSData *largeSize = [fileHandle readDataOfLength:sizeof(size_t)];
        actualSize = CFSwapInt64BigToHost(*(uint64_t *)[largeSize bytes]);

    // if size == zero, then the real size extends to the end of file. This case should only be at top level.
    // if the size reported in the atom extends past end of container, limit size to that of the container.
    // I should probably "asterisk" the size, to note in the UI that it's been changed from what was reported.
    } else if ((size == 0) || (end < offset + actualSize)) {
        actualSize = end - offset;
    }

    // Use ISO Latin-1 encoding for the atom type string.
    // ISO Latin-1 decodes © symbol present in some atom type strings.
    atomTypeString = [self stringFromFourCC:  &[fileData bytes][4] encoding: NSISOLatin1StringEncoding];

    // Now that we have the length & type, go ahead and create the atom
    // The returned atom will be a concrete subclass of Atom
    atom = [self createAtomOfType: atomTypeString
                       withLength: actualSize
                       fromOffset: offset
                       isExtended: isExtendedLength
                       withParent: parent];

    if ([atom isFullBox]) {
        off_t versionOffset;
        versionOffset = offset + 8; // Nominally right after size & type
        if (isExtendedLength) {
            versionOffset += 8; // But if it's extendedLength, version is later
        }
        [fileHandle seekToFileOffset: versionOffset];
        NSData *versionData = [fileHandle readDataOfLength:sizeof(uint32_t)];
        // break the four bytes into 1 byte version and 3 bytes flags
        // set flags & version in atom
        uint32_t versionAndFlags = CFSwapInt32BigToHost (*(uint32_t *)[versionData bytes]);
        atom.version = versionAndFlags >> 24;
        atom.flags = versionAndFlags & 0x00FFFFFF;
    }

    [contents addObject:atom];

    // if ((offset + actualSize) < end) { // offset + wholeAtomLength is next atom
    // offset + actualSize is beginning of next atom
    // But there may be garbage at end of file.
    // Check that we can actually read an atom header by adding 8 to offset + actualSize
    if (end >= (offset + actualSize + 8)) { // offset + wholeAtomLength is next atom.
        [self populateArray: contents
             fromFileHandle: fileHandle
                   atOffset: (offset + actualSize)
                       upTo: end
                  asChildOf: parent];
    }
}

//  The 4-character atomType is usually answered by the Class.
//  But this abstract superclass does not have an atomType
+ (NSString *)atomType
{
    return nil; // The abstact superclass does not have an atomType
}

+ (NSString *)stringFromFourCC: (const void *)fourCCPtr encoding: (NSStringEncoding) encoding
{
    char fourcc[5];
    memcpy(&fourcc, fourCCPtr, 4); // turn the 4-byte atom type into a null-terminated C string.
    fourcc[4] = '\0';
    return [NSString stringWithCString: fourcc encoding: encoding];
}

#pragma mark - Instance methods

//  Designated initializer for the Atom class cluster (except AtomUnrecognized)
//  This is typically invoked by +createAtomOfType:withLength:fromOffset:isExtended:usingFileHandle:inTree:
//  Using the class convenience method for creation handles instantiation of the correct concrete subclass.
-(instancetype) initWithLength: (size_t)atomLength
                    dataOffset: (off_t)offset
                    isExtended: (BOOL)isExtendedLength
               usingFileHandle: (NSFileHandle *)fileHandle
                    withParent: (Atom *)parent
{
    self = [super init];
    if (self) {
        self.length = atomLength;
        self.origin = offset;
        self.fileHandle = fileHandle;
        self.isExtendedLength = isExtendedLength;
        self.parent = parent;
    }
    return self;
}

- (void) populateArray: (NSMutableArray *)array fromOffset: (off_t)myOffset
{
    [[self class] populateArray: array
                 fromFileHandle: self.fileHandle
                       atOffset: self.origin + myOffset
                           upTo: self.origin + self.length
                      asChildOf: self];
}

-(NSString *)atomType
{
    return [[self class] atomType];
}

//  This is the human-readable atomName
//  The usual behavior is to get this from our class
//  But if this is an atom we don't understand,
//  the class will return nil. In this case, we simply supply
//  a string explaining that we don't know about this atom
- (NSString *)atomName
{
//    return [[self class] atomName] ? [[self class] atomName] : @"The meaning of this atom is unknown.";
    return @"The meaning of this atom is unknown.";

}

-(BOOL) isLeaf
{
    return YES;
}

//  YES if this atom type contains version & flags
-(BOOL) isFullBox
{
    return NO;
}

-(NSString *)nodeTitle
{
    // Most subclasses have a 4-character atom type string that is used to as the key to the atomToClassDict.
    // That 4-character atom type is also usually what we want displayed in the outline.
    // Some instances will override this, such as the "unrecognized" atom class where we get the nodeTitle from the content rather than the class, and the uuid type atoms that will supply the formatted uuid string.
    
    return [self atomType];
}

-(NSUInteger)nodeOrigin
{
    return self.origin;
}

-(NSUInteger)nodeLength
{
    return self.length;
}

-(NSUInteger)nodeEnd
{
    return self.origin + self.length;
}

-(NSString *)description
{
    return [NSString stringWithFormat: @"Atom type %@ of size %zu", [self atomType], [self length]];
}

-(NSAttributedString *)explanation
{
    // Create Font and ParagraphStyle objects
    NSFont* headerFont = [NSFont fontWithName:@"AvenirNext-Bold" size:24.0];
    NSFont* bodyFont = [NSFont fontWithName:@"AvenirNext-Medium" size:14.0];
    NSMutableParagraphStyle* myStringParaStyle1 = [NSMutableParagraphStyle new];
    myStringParaStyle1.alignment = NSCenterTextAlignment; // Header & sub-header will be centered

    // Get the string to use for the Atom Type header
    NSString *headerString = [NSString stringWithFormat:@"Atom %@\n", [self atomType]];
    NSRange headerRange = NSMakeRange(0, [headerString length]);

    // Get the string to use for the Atom Name sub-header
    NSString *subHeaderString = [self atomName];
    NSRange subHeaderRange = NSMakeRange([headerString length], [subHeaderString length]);

    // Concatenate the header & sub-header
    NSString *completeString = [headerString stringByAppendingString:subHeaderString];
    NSRange completeRange = NSMakeRange(0, [completeString length]);

    // Turn the NSString into a NSMutableAttributedString so we can apply attributes to it
    NSMutableAttributedString *explanatoryString = [[NSMutableAttributedString alloc] initWithString: completeString];

    // Apply our ParagraphStyle to the whole thing
    [explanatoryString addAttribute:NSParagraphStyleAttributeName value:myStringParaStyle1 range:completeRange];

    // Apply the header font to the header
    [explanatoryString addAttribute:NSFontAttributeName value:headerFont range:headerRange];

    // Underline the Atom Type header
    [explanatoryString addAttribute:NSUnderlineStyleAttributeName value:@1 range:headerRange];

    // Apply the sub-header font to the sub-header
    [explanatoryString addAttribute:NSFontAttributeName value:bodyFont range:subHeaderRange];

    [explanatoryString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];

    NSString* html = [self html];

    if (html) {
        NSString *charsetHeader = @"<meta charset=\"utf-8\">";
        NSString *htmlString = [charsetHeader stringByAppendingString:html];
        NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithHTML:htmlData documentAttributes:nil];
        [explanatoryString appendAttributedString:attrString];
    }

    return explanatoryString;
}

- (NSString *)asString
{
    return nil; // The abstract superclass does not have a string
}

//  This is the HTML formatted textual explantion of the content of the atom
- (NSString *)html
{
    return nil; // The abstract superclass does not have an HTML string
}

- (off_t)dataOffset
{
    // data begins after size & type, or if extended length, after size, type & extended length
    // If the atom also has version & flags, data begins after that.
    return self.origin + (self.isExtendedLength ? 16 : 8) + (self.isFullBox ? 4 : 0);
}

- (size_t)dataLength
{
    // data length is atom length minus the size & type, which may include extended length
    // If the atom also has version & flags, data begins after that.
    return self.length - (self.isExtendedLength ? 16 : 8) - (self.isFullBox ? 4 : 0);
}

- (NSArray *)children
{
    return nil; // Only subclasses of AtomParent have children
}

- (NSData *)data
{
    if (!_data) {
        [self.fileHandle seekToFileOffset:self.dataOffset];
        _data = [self.fileHandle readDataOfLength:self.dataLength];
    }
    return _data;
}

#pragma mark - Atom searching

// atomHierarchyString is a period separated string
// representing a path through the atom hierarchy.
//
// Search the parent chain for the last atom in the path.
// Once the nearest parent is found, each atom parent
// must match the previous atom type in the path.
// There may be an indeterminate number of unspecified
// atoms in between us and the last atom type in the path.

-(BOOL)isDescendantOf: (NSString *)pathString
{
    NSArray *pathArray = [pathString componentsSeparatedByString:@"."];
    NSString *nearestParentString = [pathArray lastObject];
    Atom *nextParent = self.parent;

    while (nextParent) {
        if ([[nextParent atomType] isEqualToString: nearestParentString]) {
            break; // found the nearest matching parent. Break out of the while loop with nextParent set to it.
        }
        nextParent = nextParent.parent;
    }

    // We traversed the whole parent chain and did not find a match
    if (!nextParent) {
        return NO;
    }

    // I've found the nearest matching parent (skipping over intermediaries)
    // (nextParent matches last item in path argument)
    // Now ensure all immediate parents match each parent specified

    NSEnumerator *enumerator = [pathArray reverseObjectEnumerator];
    for (NSString *pathElement in enumerator) {
        if ([[nextParent atomType] isEqualToString: pathElement]) {
            nextParent = nextParent.parent;
        } else {
            return NO;
        }
    }
    return YES;
}

-(BOOL)isImmediateDescendantOf: (NSString *)expectedParentAtomType
{
    return [[self.parent atomType] isEqualToString: expectedParentAtomType];
}

-(Atom *)findChildAtomOfType: (NSString *)typeString;
{
    return nil;
}

- (Atom *)findAtomAtPath:(NSString *)atomPath
{
    Atom *nextParent = self.parent;
    while (![nextParent isMemberOfClass:[AtomRoot class]]) {
        nextParent = nextParent.parent;
    }
    if (!nextParent) {
        return nil; // somehow didn't find root
    }
    Atom *atom = nextParent;
    NSArray *pathArray = [atomPath componentsSeparatedByString:@"."];
    for (NSString *atomName in pathArray) {
        atom = [atom findChildAtomOfType: atomName];
        if (!atom) {
            break;
        }
    }
    return atom;
}

#pragma mark - Behavior to support iTunes Metadata

- (BOOL)hasImage
{
    return NO;
}

- (NSImage *)image
{
    return nil;
}

-(BOOL)isiTunesMetadata
{
    return [self isDescendantOf:@"moov.udta.meta.ilst"];
}

#pragma mark - Data access

-(UInt16)getUInt16ValueAtOffset:(off_t)offset
{
    UInt16 result;
    NSRange uint16DataRange = NSMakeRange(offset, 2);
    [self.data getBytes:&result range:uint16DataRange];
    result = CFSwapInt16BigToHost(result);

    return result;
}

-(UInt32)getUInt32ValueAtOffset:(off_t)offset
{
    UInt32 result;
    NSRange uint32DataRange = NSMakeRange(offset, 4);
    [self.data getBytes:&result range:uint32DataRange];
    result = CFSwapInt32BigToHost(result);

    return result;
}

- (uint32_t)get1616ValueAtOffset: (off_t)offset hi:(uint16_t *)hi lo:(uint16_t *)lo
{
    uint32_t result = [self getUInt32ValueAtOffset:offset];
    *hi = result >> 16;
    *lo = result & 0xffff;
    return result;
}

- (uint16_t)get88ValueAtOffset: (off_t)offset hi:(uint8_t *)hi lo:(uint8_t *)lo
{
    uint16_t result = [self getUInt16ValueAtOffset:offset];
    *hi = result >> 8;
    *lo = result & 0xff;
    return result;
}

- (uint32_t)get230ValueAtOffset: (off_t)offset hi:(uint8_t *)hi lo:(uint32_t *)lo
{
    uint32_t result = [self getUInt32ValueAtOffset:offset];
    *hi = result >> 30;
    *lo = result & 0x3fffffff;
    return result;
}

- (NSDate *)getUInt32TimeValueAtOffset:(off_t)offset
{
    return [NSDate dateWithTimeInterval: [self getUInt32ValueAtOffset:offset]
                              sinceDate: [NSDate dateWithString:@"1904-01-01 00:00:00 +0000"]];
}

- (uint32_t)getUInt32DurationValueAtOffset: (off_t)offset
                            usingTimescale: (uint32_t)timescale
                                     hours: (uint16_t *)hours
                                   minutes: (uint16 *)minutes
                                   seconds: (double *)seconds
{
    uint32_t duration = [self getUInt32ValueAtOffset:offset];
    double total_seconds = (double)duration / (double)timescale;
    uint16_t tmp_hours = 0;
    uint16_t tmp_minutes = 0;
    double tmp_seconds = total_seconds;
    if (tmp_seconds >= 60) {
        tmp_minutes = tmp_seconds / 60;
        tmp_seconds = tmp_seconds - (tmp_minutes * 60);
    }
    if (tmp_minutes >= 60) {
        tmp_hours = total_seconds / (60 * 60);
        tmp_minutes = tmp_minutes - (tmp_hours * 60);
    }
    *hours = tmp_hours;
    *minutes = tmp_minutes;
    *seconds = tmp_seconds;
    return duration;
}

- (NSString *)stringFromFourCC: (const void *)fourCCPtr encoding: (NSStringEncoding)encoding
{
    return [[self class] stringFromFourCC: fourCCPtr encoding:encoding];
}

- (NSString *)stringFromFourCC: (const void *)fourCCPtr
{
    return [self stringFromFourCC: fourCCPtr encoding:NSUTF8StringEncoding];
}

@end
