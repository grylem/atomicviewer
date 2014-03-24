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
#import <HexFiend/HexFiend.h>

@interface MyWindowController ()

@property IBOutlet NSTextView*          placeHolderView;
@property IBOutlet NSOutlineView*       myOutlineView;
@property IBOutlet NSTreeController*    treeController;
@property IBOutlet HFTextView*          hfTextView;
@property IBOutlet NSProgressIndicator* progressIndicator;
@property IBOutlet NSSplitView*         splitView;
@property HFController*                 hfController;
@property dispatch_queue_t              dispatchQueue;
@property dispatch_io_t                 channel;
@property NSMutableArray*               contents;
@property NSAttributedString*           textViewAttributedString;
@property HFFileReference*              hfFileReference;
@property HFFileByteSlice*              currentByteSlice;

@end

@implementation MyWindowController

- (void)populateTree: (NSTreeController *)treeController fromFileAtPath: (NSString *)path onQueue: (dispatch_queue_t)queue
{
    // This is the top level parser
    // We start with the path name for the file, open it, determine size, and iterate over the top level atoms

    NSString *resolvedPath = [path stringByResolvingSymlinksInPath];
    NSDictionary *fileAttrDict = [[NSFileManager defaultManager] attributesOfItemAtPath:resolvedPath error:nil];
    size_t fileSize = [fileAttrDict fileSize];

    // create the dispatch_io channel
    self.channel = dispatch_io_create_with_path(DISPATCH_IO_RANDOM,
                                                [path UTF8String],
                                                O_RDONLY,
                                                0,
                                                queue,
                                                ^(int error) {
                                                    if (error == 0) {
                                                        //dispatch_release(self.channel);
                                                        self.channel = NULL;
                                                    }
                                                });

    [Atom populateTree: treeController childOf: nil atIndex: 0 fromChannel: self.channel onQueue: queue atOffset: 0 upTo: fileSize];
}

// -------------------------------------------------------------------------------
//	initWithWindow:window
// -------------------------------------------------------------------------------
- (id)initWithWindow:(NSWindow *)window
{
	self = [super initWithWindow:window];
	if (self)
	{
		self.contents = [[NSMutableArray alloc] init];
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
    self.dispatchQueue = dispatch_queue_create("com.atomicviewer.fileprocessing", NULL);

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
                [self populateTree: self.treeController fromFileAtPath: self.movieFilePath onQueue: self.dispatchQueue];
                self.hfFileReference = [[HFFileReference alloc] initWithPath:self.movieFilePath error:NULL];
                HFFileByteSlice *byteSlice = [[HFFileByteSlice alloc] initWithFile:self.hfFileReference];
                HFByteArray *byteArray = [[HFBTreeByteArray alloc] init];
                [byteArray insertByteSlice:byteSlice inRange:HFRangeMake(0, 0)];
                [self.hfController setByteArray:byteArray];
            }
        }];
    } else {
        [[self window] setTitleWithRepresentedFilename:self.movieFilePath];
        [self populateTree: self.treeController fromFileAtPath: self.movieFilePath onQueue: self.dispatchQueue];
        self.hfFileReference = [[HFFileReference alloc] initWithPath:self.movieFilePath error:NULL];
    }
}

-(void)outlineViewSelectionDidChange:(NSNotification*)notification
{
    NSTreeNode *treeNode = [self.myOutlineView itemAtRow:[self.myOutlineView selectedRow]];
    if (treeNode) {
        self.textViewAttributedString = [[treeNode representedObject] explanation];
        HFFileByteSlice *byteSlice = [[HFFileByteSlice alloc] initWithFile:self.hfFileReference offset:[[treeNode representedObject] origin] length:[[treeNode representedObject] dataLength]];

//        HFFileByteSlice *byteSlice = [[HFFileByteSlice alloc] initWithFile:self.hfFileReference];
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

@end
