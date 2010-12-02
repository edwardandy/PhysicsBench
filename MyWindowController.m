//
//  MyWindowController.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/7/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "MyWindowController.h"
#import "TreeController.h"
#import "GCTabController.h"
#import "BaseGridView.h"
#import "FrameworkManager.h"
#import "Document.h"
#import "GraphicsCocos2dAppDelegate.h"


//=========================
// Private class Methods
//
//=========================
@interface MyWindowController (PrivateMethods)

- (void) populateMenu;
- (void) menuItemResponder:(id)sender;
@end



//=========================
// Class Implementation
//
//=========================
@implementation MyWindowController

@synthesize outlineController, document;

- (id) initWithWindowNibName:(NSString*)nibName {
	self = [super initWithWindowNibName:nibName];
	if (self != nil) {
		GraphicsCocos2dAppDelegate *delegate = (GraphicsCocos2dAppDelegate*) [[NSApplication sharedApplication] delegate];
		self.document = delegate.document;
		// Init goes here
		[leftView setAutoresizesSubviews:YES];
	}
	return self;
}

// -------------------------------------------------------------------------------
//	dealloc:
// -------------------------------------------------------------------------------
- (void) dealloc
{
	// Dealloc goes here
	[super dealloc];
}


#pragma mark -
#pragma mark NSWindowController

// -------------------------------------------------------------------------------
//	awakeFromNib
// -------------------------------------------------------------------------------
- (void)awakeFromNib {
		
	
	
	// Left View
	// Create our outline view
	treeController = [[TreeController alloc] initWithNibName:@"TreeOutlineView" bundle:nil withController:outlineController];
	[treeController.view setFrame:leftView.frame];

	[leftView addSubview:treeController.view];
	
	// Middle View
	// Create our tab view with a physics grid
	
	BaseGridView *grid = [[BaseGridView alloc] initWithFrame:middleView.bounds];
//	[middleView addSubview:grid];
	tabController = [[GCTabController alloc] initWithView:grid controller:outlineController];
	
	[middleView addSubview:tabController.view];

	
	// Right View
	// Create our properties view & hide
	
	
	// Toolbar Menu
	[self populateMenu];
	
	
}

- (void)windowDidLoad {
	[tabController performBinding];
}


// -------------------------------------------------------------------------------
//	addPhysicsGroup:(id)sender
// -------------------------------------------------------------------------------
- (IBAction) addPhysicsGroup:(id)sender {
	[treeController addNewGroupFromMenu:sender];
}



// -------------------------------------------------------------------------------
//	populateMenu:
// -------------------------------------------------------------------------------
- (void) populateMenu 
{
	// Lets go ahead and update the shapes menu
	FrameworkManager *sharedMgr = [FrameworkManager sharedFrameworkManager];
	NSArray *shapes = {[sharedMgr fetchStringsOfShapesTypes]};
	[shapesMenu setAutoenablesItems:YES];
	NSString *name;
	for (name in shapes) {
		NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:name action:@selector(menuItemResponder:) keyEquivalent:@""];
		
		// Unfortunantely we need to create a call back to the shared manager
		// to hook menu items to framework, this is very strict coupling and presents
		// a major issue since we are creating multiple points of failure
		
		[menuItem setEnabled:YES];
		[menuItem setTarget:self];
		[shapesMenu addItem:menuItem];
		[menuItem release];
		
	}
	[shapesMenu update];
}

// -------------------------------------------------------------------------------
//	menuItemResponder:
// -------------------------------------------------------------------------------
- (void) menuItemResponder:(id)sender {
	// Get our item name
	NSMenuItem *item = (NSMenuItem*) sender;
	// Create our object
	PhysicsObject *pObj = [[FrameworkManager sharedFrameworkManager] initObjectWithKey:item.title];
	// Add to our controller
	[treeController addChild:item.title withContents:pObj];
	
}

@end
