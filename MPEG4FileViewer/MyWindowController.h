//
//  MyWindowController.h
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 9/3/13.
//  Copyright (c) 2013 Jay O'Conor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyWindowController : NSWindowController

@property NSString *movieFilePath; // This will be set by AppDelegate if file dropped on app icon

+ (BOOL)hasOpenWindows;
- (instancetype)initWithFilename:(NSString *)filename;

@end
