//
//  MyWindowController.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 8/26/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class SeparatorCell, Document;

@interface MyWindowController2 : NSWindowController {
	IBOutlet NSOutlineView		*myOutlineView;
	IBOutlet NSTreeController	*treeController;
	IBOutlet NSView				*placeHolderView;
	IBOutlet NSMenu				*shapesMenu;
	IBOutlet NSView				*propertiesView;
	
	
	// cached images for generic folder and url document
	NSView						*currentView;
	NSImage						*folderImage;
	NSImage						*urlImage;
	
	NSMutableArray				*contents;
	SeparatorCell				*separatorCell;	// the cell used to draw a separator line in the outline view
	
	BOOL						buildingOutlineView;	// signifies we are building the outline view at launch time
	BOOL						retargetWebView;
	
	
	@private	
	Document *					document;
}


//********************* Accesors  ********************
- (void)setContents:(NSArray *)newContents;
- (NSMutableArray *)contents;

//********************* Actions  ********************
- (IBAction) addPhysicsGroup:(id)sender;

//********************* Methods  ********************
- (void) addGroupToDocument:(NSString*)groupName withName:(NSString*)folderName;
- (void) populateMenu;

@end
