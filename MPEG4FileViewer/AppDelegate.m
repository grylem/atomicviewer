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

@end

@implementation AppDelegate

// -------------------------------------------------------------------------------
//	applicationDidFinishLaunching:notification
// -------------------------------------------------------------------------------
- (void)applicationDidFinishLaunching:(NSNotification*)notification
{
	// load the app's main window for display
    [self openDocument:self];
}

- (void)openDocument:(id)sender
{
    MyWindowController *newWindowController = [[MyWindowController alloc] initWithWindowNibName:@"MainWindow"];
    [newWindowController showWindow:self];
}

-(BOOL)application:(NSApplication *)sender openFile:(NSString *)filename
{
    MyWindowController *newWindowController = [[MyWindowController alloc] initWithWindowNibName:@"MainWindow"];
    newWindowController.movieFilePath = filename;
    [newWindowController showWindow:self];
    return YES;
}
@end
