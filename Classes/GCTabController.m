//
//  GCTabController.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/10/10.
//  Copyright (c) 2010 Personal. All rights reserved.
//

#import "GCTabController.h"
#import "PhysicsGrid.h"
#import "Document.h"
#import "GraphicsCocos2dAppDelegate.h"


@implementation GCTabController

@synthesize grid;

// -------------------------------------------------------------------------------
//	init:
// -------------------------------------------------------------------------------
- (id)init {
	return [self initWithNibName:nil bundle:nil];
}

// -------------------------------------------------------------------------------
//	init:
// -------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nil bundle:nil];
	if (self != nil) {
		// Init goes here, we want to force our own loadview
		
	}
	return self;
}

- (id) initWithView:(NSView*) view controller:(NSTreeController*)tController; {
	self = [super initWithNibName:nil bundle:nil];
	if (self != nil) {
		grid = (PhysicsGrid*)view;
		
        GraphicsCocos2dAppDelegate *appDelegate = (GraphicsCocos2dAppDelegate*)[[NSApplication sharedApplication] delegate];
        document = [appDelegate document];
        
        [grid gridWithDocument:document];
        				
	}
	return self;
}

// -------------------------------------------------------------------------------
//	loadView:
// -------------------------------------------------------------------------------
- (void)loadView {
	[grid setAutoresizesSubviews:YES];
	[self setView:grid];
}

// -------------------------------------------------------------------------------
//	dealloc:
// -------------------------------------------------------------------------------
- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

@end
