//
//  GraphicsCocos2dAppDelegate.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 8/25/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "GraphicsCocos2dAppDelegate.h"
#import "MyWindowController.h"
#import "Document.h"

@implementation GraphicsCocos2dAppDelegate

@synthesize document, windowController;

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	// We will insert loader in here, by default we will create
	// a document during testing
	document = [[Document alloc] init];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	windowController = [[MyWindowController alloc]  initWithWindowNibName:@"MainWindow"];
	[windowController showWindow:self];
	
	
}

- (void) dealloc
{
	[windowController release];
	[document release];
	[super dealloc];
}


@end
