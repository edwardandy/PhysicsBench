//
//  GCTabController.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/10/10.
//  Copyright (c) 2010 Personal. All rights reserved.
//

#import "GCTabController.h"
#import "BaseGridView.h"
#import "Document.h"
#import "GraphicsCocos2dAppDelegate.h"

#import "ChildNode.h"

@implementation GCTabController

@synthesize grid, treeController, content, selectionIndexPaths, document, oldArray, subChildren;

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
		grid = (BaseGridView*)view;
		treeController = tController;
		
				
		// Init goes here, we want to force our own loadview
//		[self setView:view];		
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

// 
- (void) performBinding {
    //[self addObserver:self forKeyPath:@"treeController.arrangedObjects.nodeTitle" options:0 context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	NSLog(@"here");	

    for (id keys in [change allKeys] ) {
        id value = [change objectForKey:keys];
        NSLog(@"key: %@ value %@", keys, value);
        
    }
    

/*
    NSLog(@"Index Path: %@", [treeController selectionIndexPath]);
    NSTreeNode *nodeT = [[treeController arrangedObjects] descendantNodeAtIndexPath:[treeController selectionIndexPath]];
    ChildNode* node   = [nodeT representedObject];
    
    
    NSLog(@"Node Title: %@", [node nodeTitle]);
    
*/
}



// -------------------------------------------------------------------------------
//	dealloc:
// -------------------------------------------------------------------------------
- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

@end
