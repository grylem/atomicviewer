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
	IBOutlet NSTreeController	*treeController;
	IBOutlet NSView				*placeHolderView;
	IBOutlet NSSplitView		*splitView;
	
    dispatch_queue_t            dispatchQueue;
		
	NSView						*currentView;
	
	BOOL						buildingOutlineView; // signifies building the outline view at launch time
    
	
}

@property dispatch_io_t channel;
@property NSMutableArray *contents;

@end

@implementation MyWindowController

-(void)reloadOutlineView
{
    [myOutlineView reloadData];
}

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

- (void)populateContents: (NSMutableArray *)contents fromFileAtPath: (NSString *)path onQueue: (dispatch_queue_t)queue
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

    [Atom populateContents: self.contents fromChannel: self.channel onQueue: queue atOffset: 0 upTo: statbuf.st_size];
}



// -------------------------------------------------------------------------------
//	initWithWindow:window
// -------------------------------------------------------------------------------
- (id)initWithWindow:(NSWindow *)window
{
	self = [super initWithWindow:window];
	if (self)
	{
        NSString *movieFilePath = [self getMovieFilePath];
		self.contents = [[NSMutableArray alloc] init];
        dispatchQueue = dispatch_queue_create("com.atomicviewer.fileprocessing", NULL);
        [self populateContents: self.contents fromFileAtPath: movieFilePath onQueue: dispatchQueue];
	}
	
	return self;
}

// -------------------------------------------------------------------------------
//	awakeFromNib
// -------------------------------------------------------------------------------
- (void)awakeFromNib
{
}
@end
