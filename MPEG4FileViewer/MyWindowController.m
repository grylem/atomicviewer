//
//  MyWindowController.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 9/3/13.
//  Copyright (c) 2013 Jay O'Conor. All rights reserved.
//

#import "MyWindowController.h"
#import <sys/stat.h>
#import "Atom.h"
#import "AtomUnrecognized.h"
#import <HexFiend/HexFiend.h>

@interface MyWindowController ()

// These properties are not part of the public interface

@property IBOutlet NSTextView           *placeHolderView;
@property IBOutlet NSTextView           *textWithImageView;
@property IBOutlet NSOutlineView        *myOutlineView;
@property IBOutlet HFTextView           *hfTextView;
@property IBOutlet NSProgressIndicator  *progressIndicator;
@property IBOutlet NSImageView          *imageView;
@property IBOutlet NSTabView            *tabView;
@property HFController                  *hfController;
@property NSAttributedString            *textViewAttributedString;
@property HFFileReference               *hfFileReference;
@property NSFileHandle                  *fileHandle;
@property NSString                      *movieFilePath;
@property Atom                          *root;

@end

@implementation MyWindowController

static NSMutableArray *windowControllers;   // Strong reference to each window's controller to keep it from vanishing
static dispatch_once_t pred;                // dispatch_once predicate for initialization of windowControllers and columnTitles
static NSArray *columnTitles;               // 2D array of menu names for hide/show table columns

+ (BOOL)hasOpenWindows
{
    return ([windowControllers count] != 0);
}

#pragma mark - Designated Initializer

- (instancetype)initWithFilename:(NSString *)filename
{
    self = [super initWithWindowNibName:@"MainWindow"];
    if (self) {
    _movieFilePath = filename;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFilename:nil];
}

- (void)createRootAtomFromFileAtPath: (NSString *)path
{
    NSString *resolvedPath = [path stringByResolvingSymlinksInPath];
    NSDictionary *fileAttrDict = [[NSFileManager defaultManager] attributesOfItemAtPath:resolvedPath error:nil];
    size_t fileSize = [fileAttrDict fileSize];

    self.fileHandle = [NSFileHandle fileHandleForReadingAtPath:resolvedPath];

    self.root = [Atom createRootWithFileHandle: self.fileHandle ofSize: fileSize];

    [self.myOutlineView reloadData];
}

#pragma mark - Window management methods

// -------------------------------------------------------------------------------
//	initWithWindow:window
// -------------------------------------------------------------------------------
- (id)initWithWindow:(NSWindow *)window
{
	self = [super initWithWindow:window];
	if (self) {
        dispatch_once (&pred, ^{
            windowControllers = [NSMutableArray new];
            // Array of Arrays
            columnTitles = @[ @[@"Show Offset", @"Hide Offset"],
                              @[@"Show Length", @"Hide Length"],
                              @[@"Show End",    @"Hide End"]
                              ];
        });
        [windowControllers addObject:self];
	}
	return self;
}

// -------------------------------------------------------------------------------
//	awakeFromNib
// -------------------------------------------------------------------------------
- (void)awakeFromNib
{
    self.hfController = [self.hfTextView controller];
    [self.hfController setBytesPerColumn:4];
    [self.hfController setEditable:NO];
}

-(void)windowDidLoad
{
    if (!self.movieFilePath) {
        NSOpenPanel *panel = [NSOpenPanel openPanel];
        [panel setCanChooseDirectories:NO];
        [panel setCanChooseFiles:YES];
        [panel setAllowsMultipleSelection:NO];
        [panel setAllowedFileTypes:@[(NSString *)kUTTypeMPEG4,
                                     (NSString *)kUTTypeQuickTimeMovie]];

        [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
            if (result == NSFileHandlingPanelOKButton) {
                self.movieFilePath = [[panel URL] path];
                [[self window] setTitleWithRepresentedFilename:self.movieFilePath];
                [self createRootAtomFromFileAtPath: self.movieFilePath];
                self.hfFileReference = [[HFFileReference alloc] initWithPath:self.movieFilePath error:NULL];
                HFFileByteSlice *byteSlice = [[HFFileByteSlice alloc] initWithFile:self.hfFileReference];
                HFByteArray *byteArray = [[HFBTreeByteArray alloc] init];
                [byteArray insertByteSlice:byteSlice inRange:HFRangeMake(0, 0)];
                [self.hfController setByteArray:byteArray];
            } else {
                [panel orderOut:self];
                [self.window performClose: nil];
            }
        }];
    } else {
        [[self window] setTitleWithRepresentedFilename:self.movieFilePath];
        [self createRootAtomFromFileAtPath: self.movieFilePath];
        self.hfFileReference = [[HFFileReference alloc] initWithPath:self.movieFilePath error:NULL];
    }
}

- (void)windowWillClose:(NSNotification *)notification
{
    [_fileHandle closeFile];
    [_hfFileReference close];
    _fileHandle = nil;
    _hfFileReference = nil;
    [windowControllers removeObject:self];
}

#pragma mark - Outline view delegate methods

-(void)outlineViewSelectionDidChange:(NSNotification*)notification
{

    // There's a chance the file has been closed behind our back.
    // If that's the case, Hex Fiend view will fail in an unfriendly manner
    // Test the file descriptor first to see if it's still valid.

    struct stat fileStat;
    int success = fstat([self.fileHandle fileDescriptor], &fileStat);
    if (success == -1) {
        NSLog(@"fstat() failed with %d, %s", errno, strerror(errno));
        NSAlert *alert = [NSAlert new];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert setMessageText:@"The file is no longer available"];
        [alert setInformativeText:@"The window will now be closed"];
        [alert beginSheetModalForWindow: self.window
                      completionHandler: ^(NSModalResponse result){
                          [[alert window] orderOut:self];
                          [self.window performClose:nil];
         }];
    } else {
        Atom *atom = [self.myOutlineView itemAtRow:[self.myOutlineView selectedRow]];
        if (atom) {
            if ([atom hasImage]) {
                [self.tabView selectTabViewItemAtIndex:1];
                [self.imageView setImage: [atom image]];
            } else {
                [self.placeHolderView scrollPoint:NSZeroPoint];
                [self.tabView selectTabViewItemAtIndex:0];
            }
            self.textViewAttributedString = [atom explanation];
            HFFileByteSlice *byteSlice = [[HFFileByteSlice alloc] initWithFile:self.hfFileReference
                                                                        offset:[atom origin]
                                                                        length:[atom length]];
            HFByteArray *byteArray = [[HFBTreeByteArray alloc] init];
            [byteArray insertByteSlice:byteSlice inRange:HFRangeMake(0, 0)];
            [self.hfController setByteArray:byteArray];
        } else {
            [self.tabView selectTabViewItemAtIndex:0];
            self.textViewAttributedString = [[NSAttributedString alloc] initWithString:@""];
            HFFileByteSlice *byteSlice = [[HFFileByteSlice alloc] initWithFile:self.hfFileReference];
            HFByteArray *byteArray = [[HFBTreeByteArray alloc] init];
            [byteArray insertByteSlice:byteSlice inRange:HFRangeMake(0, 0)];
            [self.hfController setByteArray:byteArray];
        }
    }
}

// Apply additional attribute(s) to an unrecognized atom.
// We do this here, rather than in AtomUnrecognized so we can get all the other values of how the system prepares the cell for display (font, etc).
// Having AtomUnrecognized supply an NSAttributedString bypasses all the system default outline display behavior.

-(void) outlineView: (NSOutlineView *)outlineView willDisplayCell: (id)cell forTableColumn: (NSTableColumn *)tableColumn item: (id)item
{
    if ([item isMemberOfClass:[AtomUnrecognized class]]) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:[cell attributedStringValue]];
        [string addAttribute:NSObliquenessAttributeName value:[NSNumber numberWithFloat:0.40]range:NSMakeRange(0, [string length])];
        [cell setAttributedStringValue:string];
    }
}

#pragma mark - Outline view data source methods

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(Atom *)item
{
    if (item == nil) {
        return self.root.children[index];
    } else {
        return (item.children)[index];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(Atom *)item
{
    return ![item isLeaf];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(Atom *)item
{
    if (item == nil) {
        return [self.root.children count];
    }
    return [item.children count];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(Atom*)item
{
    if ([tableColumn.identifier isEqual: @"outline"]) {
        return [item nodeTitle];
    } else if ([tableColumn.identifier isEqual: @"origin"]) {
        return @([item nodeOrigin]);
    } else if ([tableColumn.identifier isEqual: @"length"]) {
        return @([item nodeLength]);
    } else if ([tableColumn.identifier isEqual: @"end"]) {
        return @([item nodeEnd]);
    }
    return @"";
}

#pragma mark - Menu manipulation

// item tag is index into tableColumns
// item tag - 1 is index into columnTitles
//
- (BOOL)validateMenuItem:(NSMenuItem *)item
{
    [item setTitle:columnTitles[[item tag] - 1][[[self.myOutlineView tableColumns][[item tag]] isHidden] ? 0 : 1]];
    return YES;
}

//  This relies on the menu item's tag being the same as the table column index
- (void)showHideColumn:(id)sender
{
    NSTableColumn *tableColumn = [self.myOutlineView tableColumns][[sender tag]];
    [tableColumn setHidden: [tableColumn isHidden] ? NO : YES];
}

@end
