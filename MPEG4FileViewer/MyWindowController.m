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
	IBOutlet NSOutlineView		*myOutlineView;
//	IBOutlet NSTreeController	*treeController;
	IBOutlet NSView				*placeHolderView;
	IBOutlet NSSplitView		*splitView;
    dispatch_queue_t            dispatchQueue;
		
	NSView						*currentView;
	
	BOOL						buildingOutlineView; // signifies building the outline view at launch time
    
	
}

@property dispatch_io_t channel;
@property NSMutableArray *contents;
@property IBOutlet NSTreeController *treeController;
@property NSString *movieFilePath;

@end

@implementation MyWindowController

- (NSString *) getMovieFilePath
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:NO];
    [panel setAllowedFileTypes:@[(NSString *)kUTTypeMPEG4]];
    
    NSInteger clicked = [panel runModal];
    if (clicked != NSFileHandlingPanelOKButton) {
        [NSApp terminate:self];
    }
    
    NSURL *movieFile = [panel URL];
    
    NSString *movieFilePath = [movieFile path];
    
    return movieFilePath;
 
}

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
    self.movieFilePath = [self getMovieFilePath];
    [[self window] setTitleWithRepresentedFilename:self.movieFilePath];
    dispatchQueue = dispatch_queue_create("com.atomicviewer.fileprocessing", NULL);
    [self populateTree: self.treeController fromFileAtPath: self.movieFilePath onQueue: dispatchQueue];
}


@end
