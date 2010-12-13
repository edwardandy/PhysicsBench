//
//  TreeController.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/7/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SeparatorCell, Document;

typedef enum {
	FOLDER,
	NODE
	
} ObjectType;


// -------------------------------------------------------------------------------
//	TreeController
//
//	This is our primary class that will create the outline view. We have created
// inner classes to handle the work of additional data.
// -------------------------------------------------------------------------------
@interface TreeController : NSViewController {

	@public
		IBOutlet NSOutlineView				*outlineView;
		IBOutlet NSTreeController			*treeController;
		IBOutlet NSTableColumn				*tableOutletColumn;
	
		NSImage						*folderImage;
	
		SeparatorCell				*separatorCell;	// the cell used to draw a separator line in the outline view
		BOOL						buildingOutlineView;	// signifies we are building the outline view at launch time
		NSMutableArray				*contents;
	
	@private
		Document *					document;
}

@property (nonatomic, assign)  __weak NSTreeController			*treeController;
@property (nonatomic, assign)  __weak Document *					document;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withController:(NSTreeController*)controller;

@end