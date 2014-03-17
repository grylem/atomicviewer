//
//  AppDelegate.m
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 6/10/13.
//  Copyright (c) 2013 Jay O'Conor. All rights reserved.
//

#import "AppDelegate.h"
#import "MyWindowController.h"

@interface AppDelegate ()
@property MyWindowController *myWindowController;
@end

@implementation AppDelegate

// -------------------------------------------------------------------------------
//	applicationShouldTerminateAfterLastWindowClosed:sender
//
//	NSApplication delegate method placed here so the sample conveniently quits
//	after we close the window.
// -------------------------------------------------------------------------------
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender
{
	return YES;
}

// -------------------------------------------------------------------------------
//	applicationDidFinishLaunching:notification
// -------------------------------------------------------------------------------
- (void)applicationDidFinishLaunching:(NSNotification*)notification
{
    
	// load the app's main window for display
	_myWindowController = [[MyWindowController alloc] initWithWindowNibName:@"MainWindow"];
	[self.myWindowController showWindow:self];
}

@end
