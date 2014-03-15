//
//  MyWindowController.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 9/3/13.
//  Copyright (c) 2013 Jay O'Conor. All rights reserved.
//

#import "MyWindowController.h"
#import <sys/stat.h>
#import "Atoms.h"

@interface MyWindowController ()
{
	IBOutlet NSOutlineView		*myOutlineView;
	IBOutlet NSTreeController	*treeController;
	IBOutlet NSView				*placeHolderView;
	IBOutlet NSSplitView		*splitView;
//	IBOutlet WebView			*webView;
//	IBOutlet NSProgressIndicator *progIndicator;
	
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
/*
- (Atom *)createAtomOfType: (NSString *)atomType withLength: (size_t)atomLength fromOffset: (off_t)offset usingChannel: (dispatch_io_t)channel onQueue: (dispatch_queue_t) queue
{
    NSDictionary *atomToClassDict = @{@"ftyp" : [AtomFtyp class],
                                      @"free" : [AtomFree class],
                                      @"mdat" : [AtomMdat class],
                                      @"moov" : [AtomMoov class]};
        
    Atom *newAtom = [[atomToClassDict[atomType] alloc] initWithLength: atomLength dataOffset: offset usingChannel: channel onQueue: (dispatch_queue_t)queue];
    
    return newAtom;
}

- (void)populateContents: (NSMutableArray *)atomArray fromChannel: (dispatch_io_t)channel onQueue: (dispatch_queue_t)queue atOffset: (off_t)offset upTo: (off_t)end
{
    dispatch_io_read(self.channel,
                     offset,
                     8,
                     queue,
                     ^(bool done, dispatch_data_t data, int error) {
                         const void *buffer = NULL;
                         off_t dataOffset = 0;
                         size_t length = 0;
                         size_t wholeAtomLength;
                         Atom *atom;
                         char atomType[5];
                         if (error == 0) {
                             // I don't care about the returned tmpData. Just need the buffer.
                             __unused dispatch_data_t tmpData = dispatch_data_create_map(data,
                                                                                         &buffer,
                                                                                         &length);
                             dataOffset = offset + length;
                         }
                         // We've read 8 bytes: length & atom type
                         // byteswap the length & copy the atom type to a C string
                         uint32_t atomLength = CFSwapInt32BigToHost (*(uint32_t *)buffer);
                         wholeAtomLength = atomLength;
                         memcpy(&atomType, &buffer[4], 4);
                         atomType[4] = '\0';
                         if (atomLength == 1) {
                             dispatch_fd_t fd = dispatch_io_get_descriptor(channel);
                             lseek(fd, dataOffset, SEEK_SET);
                             uint64_t extendedAtomLength;
                             read(fd, &extendedAtomLength, sizeof(extendedAtomLength));
                             length += sizeof(extendedAtomLength);
                             dataOffset += sizeof(extendedAtomLength);
                             wholeAtomLength = CFSwapInt64BigToHost(extendedAtomLength);
                         }
                         atom = [self createAtomOfType: @(atomType) withLength: wholeAtomLength-length fromOffset: dataOffset usingChannel: channel onQueue: queue];
                         [atomArray addObject: atom];
                         if ((offset + wholeAtomLength) < end) {
                             [self populateContents:atomArray fromChannel:channel onQueue:queue atOffset:(offset + wholeAtomLength) upTo:end];
                             
                         }
                     });
}
*/

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
