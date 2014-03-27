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
#import "AtomParent.h"
#import <HexFiend/HexFiend.h>

@interface MyWindowController ()

@property IBOutlet NSTextView*          placeHolderView;
@property IBOutlet NSOutlineView*       myOutlineView;
@property IBOutlet HFTextView*          hfTextView;
@property IBOutlet NSProgressIndicator* progressIndicator;
@property IBOutlet NSSplitView*         splitView;
@property HFController*                 hfController;
@property NSMutableArray*               contents;
@property NSAttributedString*           textViewAttributedString;
@property HFFileReference*              hfFileReference;
@property HFFileByteSlice*              currentByteSlice;
@property NSFileHandle*                 fileHandle;

@end

@implementation MyWindowController

static NSMutableArray *windowControllers;
static dispatch_once_t pred;

- (void)populateOutline: (NSMutableArray *)contents fromFileAtPath: (NSString *)path
{
    // This is the top level parser
    // We start with the path name for the file, open it, determine size, and iterate over the top level atoms

    NSString *resolvedPath = [path stringByResolvingSymlinksInPath];
    NSDictionary *fileAttrDict = [[NSFileManager defaultManager] attributesOfItemAtPath:resolvedPath error:nil];
    size_t fileSize = [fileAttrDict fileSize];

    self.fileHandle = [NSFileHandle fileHandleForReadingAtPath:resolvedPath];

    [Atom populateOutline:contents fromFileHandle: self.fileHandle atOffset:0 upTo:fileSize];
    [self.myOutlineView reloadData];
}

#pragma mark - Window management methods

// -------------------------------------------------------------------------------
//	initWithWindow:window
// -------------------------------------------------------------------------------
- (id)initWithWindow:(NSWindow *)window
{
	self = [super initWithWindow:window];
	if (self)
	{
		self.contents = [[NSMutableArray alloc] init];

        dispatch_once (&pred, ^{
            windowControllers = [NSMutableArray new];
        });
        [windowControllers addObject:self ];
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
        [panel setAllowedFileTypes:@[(NSString *)kUTTypeMPEG4]];

        [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
            if (result == NSFileHandlingPanelOKButton) {
                self.movieFilePath = [[panel URL] path];
                [[self window] setTitleWithRepresentedFilename:self.movieFilePath];
                [self populateOutline: self.contents fromFileAtPath: self.movieFilePath];
                self.hfFileReference = [[HFFileReference alloc] initWithPath:self.movieFilePath error:NULL];
                HFFileByteSlice *byteSlice = [[HFFileByteSlice alloc] initWithFile:self.hfFileReference];
                HFByteArray *byteArray = [[HFBTreeByteArray alloc] init];
                [byteArray insertByteSlice:byteSlice inRange:HFRangeMake(0, 0)];
                [self.hfController setByteArray:byteArray];
            }
        }];
    } else {
        [[self window] setTitleWithRepresentedFilename:self.movieFilePath];
        [self populateOutline: self.contents fromFileAtPath: self.movieFilePath];
        self.hfFileReference = [[HFFileReference alloc] initWithPath:self.movieFilePath error:NULL];
    }
}

-(BOOL)windowShouldClose:(id)sender
{
    [windowControllers removeObject:self];
    return YES;
}

#pragma mark - Outline view delegate methods

-(void)outlineViewSelectionDidChange:(NSNotification*)notification
{
    Atom *atom = [self.myOutlineView itemAtRow:[self.myOutlineView selectedRow]];
    if (atom) {
        self.textViewAttributedString = [atom explanation];
        HFFileByteSlice *byteSlice = [[HFFileByteSlice alloc] initWithFile:self.hfFileReference
                                                                    offset:[atom origin]
                                                                    length:[atom dataLength]];
        HFByteArray *byteArray = [[HFBTreeByteArray alloc] init];
        [byteArray insertByteSlice:byteSlice inRange:HFRangeMake(0, 0)];
        [self.hfController setByteArray:byteArray];
    } else {
        self.textViewAttributedString = [[NSAttributedString alloc] initWithString:@""];
        HFFileByteSlice *byteSlice = [[HFFileByteSlice alloc] initWithFile:self.hfFileReference];
        HFByteArray *byteArray = [[HFBTreeByteArray alloc] init];
        [byteArray insertByteSlice:byteSlice inRange:HFRangeMake(0, 0)];
        [self.hfController setByteArray:byteArray];
    }
}

#pragma mark - Outline view data source methods

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(AtomParent *)item
{
    if (item == nil) {
        return _contents[index];
    } else {
        return (item.children)[index];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(Atom *)item
{
    return ![item isLeaf];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(AtomParent *)item
{
    if (item == nil) {
        return [_contents count];
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

@end
