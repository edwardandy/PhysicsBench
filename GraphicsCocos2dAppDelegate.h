//
//  GraphicsCocos2dAppDelegate.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 8/25/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MyWindowController;
@class Document;

@interface GraphicsCocos2dAppDelegate : NSObject <NSApplicationDelegate> {
	MyWindowController	*windowController;

	// Shared instance of our current document
	// We will likely move this to a document manager
	Document			*document;
}

@property (nonatomic, retain) 	Document			*document;
@property (nonatomic, retain) 	MyWindowController  *windowController;

@end
