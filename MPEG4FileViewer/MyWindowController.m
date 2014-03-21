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

@interface MyWindowController ()
{
    IBOutlet NSOutlineView*     myOutlineView;
    IBOutlet NSTreeController*  _treeController;
    IBOutlet NSTextView*        placeHolderView;
    IBOutlet NSSplitView*       splitView;
    dispatch_queue_t            dispatchQueue;
    NSView*                     currentView;
    BOOL                        buildingOutlineView; // signifies building the outline view at launch time
}

@property dispatch_io_t         channel;
@property NSMutableArray*       contents;
@property NSAttributedString*   textViewAttributedString;


@end

@implementation MyWindowController

//- (NSString *) getMovieFilePathOnWindow:(NSWindow *)window
//{
//    NSOpenPanel *panel = [NSOpenPanel openPanel];
//    [panel setCanChooseDirectories:NO];
//    [panel setCanChooseFiles:YES];
//    [panel setAllowsMultipleSelection:NO];
//    [panel setAllowedFileTypes:@[(NSString *)kUTTypeMPEG4]];
//
//    [panel beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
//        self.movieFilePath = [[panel URL] path];
//    }];
//
//    return (self.movieFilePath = [[panel URL] path]);
//
//}

- (void)populateTree: (NSTreeController *)treeController fromFileAtPath: (NSString *)path onQueue: (dispatch_queue_t)queue
{
    // This is the top level parser
    // We start with the path name for the file, open it, determine size, and iterate over the top level atoms

    struct stat statbuf;

    stat([path UTF8String], &statbuf);

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

    [Atom populateTree: treeController childOf: nil atIndex: 0 fromChannel: self.channel onQueue: queue atOffset: 0 upTo: statbuf.st_size];
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
}

-(void)windowDidLoad
{
    dispatchQueue = dispatch_queue_create("com.atomicviewer.fileprocessing", NULL);

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
                [self populateTree: _treeController fromFileAtPath: self.movieFilePath onQueue: dispatchQueue];
            }
        }];
    } else {
        [[self window] setTitleWithRepresentedFilename:self.movieFilePath];
        [self populateTree: _treeController fromFileAtPath: self.movieFilePath onQueue: dispatchQueue];
    }
}

-(void)outlineViewSelectionDidChange:(NSNotification*)notification
{
    NSTreeNode *treeNode = [myOutlineView itemAtRow:[myOutlineView selectedRow]];
    if (treeNode) {
        self.textViewAttributedString = [[treeNode representedObject] explanation];
    } else {
        [placeHolderView setString:@""];
    }
}

@end
