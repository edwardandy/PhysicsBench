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
		IBOutlet NSTableColumn				*tableColumn;
	
		NSImage						*folderImage;
	
		SeparatorCell				*separatorCell;	// the cell used to draw a separator line in the outline view
		BOOL						buildingOutlineView;	// signifies we are building the outline view at launch time
		NSMutableArray				*contents;
	
	@private
		Document *					document;
}

@property (nonatomic, assign)  __weak NSTreeController			*treeController;
@property (nonatomic, assign)  __weak Document *					document;

- (void) addNewGroupFromMenu:(id)sender;
- (void)addChild:(NSString *)folderName withContents:(id)content;
- (void)addFolder:(NSString *)folderName;
- (void)addFolder:(NSString *)folderName withContents:(id)content;
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withController:(NSTreeController*)controller;

@end


// -------------------------------------------------------------------------------
//	TreeAdditionObj
//
//	This object is used for passing data between the main and secondary thread
//	which populates the outline view.
// -------------------------------------------------------------------------------
@interface TreeAdditionObj : NSObject
{
	NSIndexPath *indexPath;
	NSString	*nodeURL;
	NSString	*nodeName;
	BOOL		selectItsParent;
	
	
	ObjectType	type;
	id			content;
	
}

@property (nonatomic, assign) id content;
@property (readonly) ObjectType type;
@property (assign) NSIndexPath *indexPath;
@property (readonly) NSString *nodeURL;
@property (readonly) NSString *nodeName;
@property (readonly) BOOL selectItsParent;


@end