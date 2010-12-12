//
//  MyWindowController.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 8/26/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "MyWindowController2.h"
#import "ChildNode.h"
#import "SeparatorCell.h"
#import "ImageAndTextCell.h"
#import "PhysicsGrid.h"


#import "Document.h"
#import "GraphicsCocos2dAppDelegate.h"
#import "FrameworkManager.h"


#define COLUMNID_NAME			@"NameColumn"	// the single column name in our outline view
#define INITIAL_INFODICT		@"Outline"		// name of the dictionary file to populate our outline view

#define ICONVIEW_NIB_NAME		@"IconView"		// nib name for the icon view
#define FILEVIEW_NIB_NAME		@"FileView"		// nib name for the file view
#define CHILDEDIT_NAME			@"ChildEdit"	// nib name for the child edit window controller

#define UNTITLED_NAME			@"Untitled"		// default name for added folders and leafs

#define HTTP_PREFIX				@"http://"

// default folder titles
#define PHYSICS_NAME			@"PHYSICS"




// keys in our disk-based dictionary representing our outline view's data
#define KEY_NAME				@"name"
#define KEY_URL					@"url"
#define KEY_SEPARATOR			@"separator"
#define KEY_GROUP				@"group"
#define KEY_FOLDER				@"folder"
#define KEY_ENTRIES				@"entries"

#define kMinOutlineViewSplit	120.0f

#define kNodesPBoardType		@"myNodesPBoardType"	// drag and drop pasteboard type

/*

typedef enum {
	FOLDER,
	NODE
	
} ObjectType;

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
}

@property (readonly) ObjectType type;
@property (assign) NSIndexPath *indexPath;
@property (readonly) NSString *nodeURL;
@property (readonly) NSString *nodeName;
@property (readonly) BOOL selectItsParent;


@end

@implementation TreeAdditionObj
@synthesize indexPath, nodeURL, nodeName, selectItsParent, type;

// -------------------------------------------------------------------------------
- (id)initWithURL:(NSString *)url withName:(NSString *)name selectItsParent:(BOOL)select
{
	self = [super init];
	
	nodeName = name;
	nodeURL = url;
	selectItsParent = select;
	type = FOLDER;
	return self;
}

// -------------------------------------------------------------------------------
- (id)initWithURL:(NSString *)url withName:(NSString *)name selectItsParent:(BOOL)select withType:(ObjectType) objType
{
	self = [super init];
	
	nodeName = name;
	nodeURL = url;
	selectItsParent = select;
	type = objType;
	return self;
}

@end

*/




// -------------------------------------------------------------------------------
//	MyWindowController
//
//	This object is used to control the main window of the application and it's functionality
// as it divides to the serpate views
// -------------------------------------------------------------------------------
@implementation MyWindowController2
/*
-(id)initWithWindow:(NSWindow *)window
{
	self = [super initWithWindow:window];
	if (self)
	{
		contents = [[NSMutableArray alloc] init];
		
		// cache the reused icon images
		folderImage = [[[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)] retain];
		[folderImage setSize:NSMakeSize(16,16)];
		
		urlImage = [[[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericURLIcon)] retain];
		[urlImage setSize:NSMakeSize(16,16)];
		
		GraphicsCocos2dAppDelegate *appDelegate = (GraphicsCocos2dAppDelegate*) [[NSApplication sharedApplication] delegate];
		document = appDelegate.document;
		NSLog(@"WARNING - REGISTER CLASS FOR DOCUMENT CHANGES");
				
		// Register our notifications
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentDidUpdateGroup:) name:DocumentDidUpdatePhysicsGroup object:nil];
	}
	
	return self;
}

// -------------------------------------------------------------------------------
//	dealloc:
// -------------------------------------------------------------------------------
- (void)dealloc
{
	[contents release];	
	[separatorCell release];
	[folderImage release];
	[urlImage release];
	
	[super dealloc];
}
// -------------------------------------------------------------------------------
//	awakeFromNib:
// -------------------------------------------------------------------------------
- (void)awakeFromNib
{
	
	[[self window] setAutorecalculatesContentBorderThickness:YES forEdge:NSMinYEdge];
	[[self window] setContentBorderThickness:30 forEdge:NSMinYEdge];
	
	// apply our custom ImageAndTextCell for rendering the first column's cells
	NSTableColumn *tableColumn = [myOutlineView tableColumnWithIdentifier:COLUMNID_NAME];
	ImageAndTextCell *imageAndTextCell = [[[ImageAndTextCell alloc] init] autorelease];
	[imageAndTextCell setEditable:YES];
	[tableColumn setDataCell:imageAndTextCell];
	
	separatorCell = [[SeparatorCell alloc] init];
    [separatorCell setEditable:NO];
	
	// build our default tree on a separate thread,
	// some portions are from disk which could get expensive depending on the size of the dictionary file:
	[NSThread detachNewThreadSelector:	@selector(populateOutlineContents:)
							 toTarget:self		// we are the target
						   withObject:nil];
	
		
	// insert an empty menu item at the beginning of the drown down button's menu and add its image
	NSImage *actionImage = [NSImage imageNamed:NSImageNameActionTemplate];
	[actionImage setSize:NSMakeSize(10,10)];
	
	NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
	//[[actionButton menu] insertItem:menuItem atIndex:0];
	[menuItem setImage:actionImage];
	[menuItem release];
	
	
	// scroll to the top in case the outline contents is very long
	[[[myOutlineView enclosingScrollView] verticalScroller] setFloatValue:0.0];
	[[[myOutlineView enclosingScrollView] contentView] scrollToPoint:NSMakePoint(0,0)];
	
	// make our outline view appear with gradient selection, and behave like the Finder, iTunes, etc.
	[myOutlineView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
	
	// drag and drop support
	[myOutlineView registerForDraggedTypes:[NSArray arrayWithObjects:
											kNodesPBoardType,			// our internal drag type
											NSURLPboardType,			// single url from pasteboard
											NSFilenamesPboardType,		// from Safari or Finder
											NSFilesPromisePboardType,	// from Safari or Finder (multiple URLs)
											nil]];
	
	PhysicsGrid *gridview = [[PhysicsGrid alloc] initWithFrame:placeHolderView.bounds];
	[placeHolderView addSubview:gridview];
	[gridview release];
	
	[self populateMenu];
}

- (void) documentDidUpdateGroup:(NSNotification *)notification
{
	NSLog(@"Notified that document was updated");
	NSDictionary *userInfo = [notification userInfo];
	ChildNode *node = (ChildNode*) [userInfo objectForKey:@"contents"];
	NSIndexPath *indexPath = (NSIndexPath*) [userInfo objectForKey:@"indexpath"];
	
	[treeController insertObject:node atArrangedObjectIndexPath:indexPath];
	
	// Final part is to re-render everything on screen, should move to own notification responder
	PhysicsGrid *grid = (PhysicsGrid*) [[placeHolderView subviews] lastObject];
	GraphicsCocos2dAppDelegate *delegate = (GraphicsCocos2dAppDelegate*) [[NSApplication sharedApplication] delegate];
	NSArray *array = delegate.document.physicsGroups;
	
	[grid renderGroupToScreen:[array lastObject]];
}












// -------------------------------------------------------------------------------
//	setContents:newContents
// -------------------------------------------------------------------------------
- (void)setContents:(NSArray*)newContents
{
	if (contents != newContents)
	{
		[contents release];
		contents = [[NSMutableArray alloc] initWithArray:newContents];
	}
}

// -------------------------------------------------------------------------------
//	contents:
// -------------------------------------------------------------------------------
- (NSMutableArray *)contents
{
	return contents;
}

// -------------------------------------------------------------------------------
//	selectParentFromSelection:
//
//	Take the currently selected node and select its parent.
// -------------------------------------------------------------------------------
- (void)selectParentFromSelection
{
	if ([[treeController selectedNodes] count] > 0)
	{
		NSTreeNode* firstSelectedNode = [[treeController selectedNodes] objectAtIndex:0];
		NSTreeNode* parentNode = [firstSelectedNode parentNode];
		if (parentNode)
		{
			// select the parent
			NSIndexPath* parentIndex = [parentNode indexPath];
			[treeController setSelectionIndexPath:parentIndex];
		}
		else
		{
			// no parent exists (we are at the top of tree), so make no selection in our outline
			NSArray* selectionIndexPaths = [treeController selectionIndexPaths];
			[treeController removeSelectionIndexPaths:selectionIndexPaths];
		}
	}
}

// -------------------------------------------------------------------------------
//	performAddFolder:treeAddition
// -------------------------------------------------------------------------------
-(void)performAddFolder:(TreeAdditionObj *)treeAddition
{
	// NSTreeController inserts objects using NSIndexPath, so we need to calculate this
	NSIndexPath *indexPath = nil;
	
	// if there is no selection, we will add a new group to the end of the contents array
	if ([[treeController selectedObjects] count] == 0)
	{
		// there's no selection so add the folder to the top-level and at the end
		indexPath = [NSIndexPath indexPathWithIndex:[contents count]];
	}
	else
	{
		// get the index of the currently selected node, then add the number its children to the path -
		// this will give us an index which will allow us to add a node to the end of the currently selected node's children array.
		//
		indexPath = [treeController selectionIndexPath];
		if ([[[treeController selectedObjects] objectAtIndex:0] isLeaf])
		{
			// user is trying to add a folder on a selected child,
			// so deselect child and select its parent for addition
			[self selectParentFromSelection];
		}
		else
		{
			indexPath = [indexPath indexPathByAddingIndex:[[[[treeController selectedObjects] objectAtIndex:0] children] count]];
		}
	}
	
	ChildNode *node = [[ChildNode alloc] init];
	[node setNodeTitle:[treeAddition nodeName]];
	
	// the user is adding a child node, tell the controller directly
	[treeController insertObject:node atArrangedObjectIndexPath:indexPath];
	
	[node release];
}

// -------------------------------------------------------------------------------
//	addFolder:folderName:
// -------------------------------------------------------------------------------
- (void)addFolder:(NSString *)folderName
{
	TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithURL:nil withName:folderName selectItsParent:NO];
	
	if (buildingOutlineView)
	{
		// add the folder to the tree controller, but on the main thread to avoid lock ups
		[self performSelectorOnMainThread:@selector(performAddFolder:) withObject:treeObjInfo waitUntilDone:YES];
	}
	else
	{
		[self performAddFolder:treeObjInfo];
	}
	
	[treeObjInfo release];
}

- (void)addFolder:(NSString *)url withName:(NSString *)nameStr selectParent:(BOOL)select {
	TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithURL:nil withName:nameStr selectItsParent:YES];
	
	if (buildingOutlineView)
	{
		// add the folder to the tree controller, but on the main thread to avoid lock ups
		[self performSelectorOnMainThread:@selector(performAddFolder:) withObject:treeObjInfo waitUntilDone:YES];
	}
	else
	{
		[self performAddFolder:treeObjInfo];
	}
	
	[treeObjInfo release];
}

// -------------------------------------------------------------------------------
//	performAddChild:treeAddition
// -------------------------------------------------------------------------------
-(void)performAddChild:(TreeAdditionObj *)treeAddition
{
	if ([[treeController selectedObjects] count] > 0)
	{
		// we have a selection
		if ([[[treeController selectedObjects] objectAtIndex:0] isLeaf])
		{
			// trying to add a child to a selected leaf node, so select its parent for add
			[self selectParentFromSelection];
		}
	}
	
	// find the selection to insert our node
	NSIndexPath *indexPath;
	if ([[treeController selectedObjects] count] > 0)
	{
		// we have a selection, insert at the end of the selection
		indexPath = [treeController selectionIndexPath];
		indexPath = [indexPath indexPathByAddingIndex:[[[[treeController selectedObjects] objectAtIndex:0] children] count]];
	}
	else
	{
		// no selection, just add the child to the end of the tree
		indexPath = [NSIndexPath indexPathWithIndex:[contents count]];
	}
	
	// create a leaf node
	ChildNode *node = [[ChildNode alloc] initLeaf];
	[node setURL:[treeAddition nodeURL]];
	
	if ([treeAddition nodeURL])
	{
		if ([[treeAddition nodeURL] length] > 0)
		{
			// the child to insert has a valid URL, use its display name as the node title
			if ([treeAddition nodeName])
				[node setNodeTitle:[treeAddition nodeName]];
			else
				[node setNodeTitle:[[NSFileManager defaultManager] displayNameAtPath:[node urlString]]];
		}
		else
		{
			// the child to insert will be an empty URL
			[node setNodeTitle:UNTITLED_NAME];
			[node setURL:HTTP_PREFIX];
		}
	}
	
	// the user is adding a child node, tell the controller directly
	[treeController insertObject:node atArrangedObjectIndexPath:indexPath];
	[document insertObject:[[PhysicsObject alloc] init] atArrangedObjectIndexPath:indexPath];
	
	[node release];
	
	// adding a child automatically becomes selected by NSOutlineView, so keep its parent selected
	if ([treeAddition selectItsParent])
		[self selectParentFromSelection];
}

// -------------------------------------------------------------------------------
//	addChild:url:withName:
// -------------------------------------------------------------------------------
- (void)addChild:(NSString *)url withName:(NSString *)nameStr selectParent:(BOOL)select
{
	TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithURL:url withName:nameStr selectItsParent:select];
	
	if (buildingOutlineView)
	{
		// add the child node to the tree controller, but on the main thread to avoid lock ups
		[self performSelectorOnMainThread:@selector(performAddChild:) withObject:treeObjInfo waitUntilDone:YES];
	}
	else
	{
		[self performAddChild:treeObjInfo];
	}
	
	[treeObjInfo release];
}


// -------------------------------------------------------------------------------
//	addEntries:
// -------------------------------------------------------------------------------
-(void)addEntries:(NSDictionary *)entries
{
	NSEnumerator *entryEnum = [entries objectEnumerator];
	
	id entry;
	while ((entry = [entryEnum nextObject]))
	{
		if ([entry isKindOfClass:[NSDictionary class]])
		{
			NSString *urlStr = [entry objectForKey:KEY_URL];
			
			if ([entry objectForKey:KEY_SEPARATOR])
			{
				// its a separator mark, we treat is as a leaf
				[self addChild:nil withName:nil selectParent:YES];
			}
			else if ([entry objectForKey:KEY_FOLDER])
			{
				// its a file system based folder,
				// we treat is as a leaf and show its contents in the NSCollectionView
				NSString *folderName = [entry objectForKey:KEY_FOLDER];
				[self addChild:urlStr withName:folderName selectParent:YES];
			}
			else if ([entry objectForKey:KEY_URL])
			{
				// its a leaf item with a URL
				NSString *nameStr = [entry objectForKey:KEY_NAME];
				[self addChild:urlStr withName:nameStr selectParent:YES];
			}
			else
			{
				// it's a generic container
				NSString *folderName = [entry objectForKey:KEY_GROUP];
				[self addFolder:folderName];
				
				// add its children
				NSDictionary *entries = [entry objectForKey:KEY_ENTRIES];
				[self addEntries:entries];
				
				[self selectParentFromSelection];
			}
		}
	}
	
	// inserting children automatically expands its parent, we want to close it
	if ([[treeController selectedNodes] count] > 0)
	{
		NSTreeNode *lastSelectedNode = [[treeController selectedNodes] objectAtIndex:0];
		[myOutlineView collapseItem:lastSelectedNode];
	}
}

// -------------------------------------------------------------------------------
//	populateOutline:
//
//	Populate the tree controller from disk-based dictionary (Outline.dict)
// -------------------------------------------------------------------------------
- (void)populateOutline
{
	NSLog(@"Populate outline has not been implemented");

}



// -------------------------------------------------------------------------------
//	addPhysicsGroupsSection:
// -------------------------------------------------------------------------------
- (void)addPhysicsGroupsSection
{
	// insert the "Devices" group at the top of our tree
	[self addFolder:PHYSICS_NAME];
	
	[self selectParentFromSelection];
}

// -------------------------------------------------------------------------------
//	addDefaultGroup:
// -------------------------------------------------------------------------------
- (void) addDefaultGroup {
	
	// Force selection to begin with default group (version 1.0)
	NSUInteger indexes[] = {0, 0};
	NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexes length:2];
	
	// create a leaf node
	NSString *title = @"DEFAULT";
	
	TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithURL:nil withName:title selectItsParent:NO withType:FOLDER];
	[treeObjInfo setIndexPath:indexPath];
	[self addObjectToTree:treeObjInfo];
	
}



// -------------------------------------------------------------------------------
//	populateOutlineContents:inObject
//
//	This method is being called on a separate thread to avoid blocking the UI
//	a startup time.
// -------------------------------------------------------------------------------
- (void)populateOutlineContents:(id)inObject
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	buildingOutlineView = YES;		// indicate to ourselves we are building the default tree at startup
	
	[myOutlineView setHidden:YES];	// hide the outline view - don't show it as we are building the contents
	
	[self addPhysicsGroupsSection];
	[self addDefaultGroup];
	
	buildingOutlineView = NO;		// we're done building our default tree
	
	// remove the current selection
	NSArray *selection = [treeController selectionIndexPaths];
	[treeController removeSelectionIndexPaths:selection];
	
	[myOutlineView setHidden:NO];	// we are done populating the outline view content, show it again
	
	[pool release];
}



#pragma mark -
#pragma mark NSOutlineView delegate

// -------------------------------------------------------------------------------
//	isSpecialGroup:
// -------------------------------------------------------------------------------
- (BOOL)isSpecialGroup:(BaseNode *)groupNode
{ 
	return ([groupNode nodeIcon] == nil &&
			[[groupNode nodeTitle] isEqualToString:PHYSICS_NAME] );
}

// -------------------------------------------------------------------------------
//	shouldSelectItem:item
// -------------------------------------------------------------------------------
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item;
{
	// We want to allow all groups 
	BaseNode* node = [item representedObject];
	return (![self isSpecialGroup:node]);
}

// -------------------------------------------------------------------------------
//	dataCellForTableColumn:tableColumn:row
// -------------------------------------------------------------------------------
- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	NSCell* returnCell = [tableColumn dataCell];
	
	if ([[tableColumn identifier] isEqualToString:COLUMNID_NAME])
	{
		// we are being asked for the cell for the single and only column
		BaseNode* node = [item representedObject];
		if ([node nodeIcon] == nil && [[node nodeTitle] length] == 0)
			returnCell = separatorCell;
	}
	
	return returnCell;
}

// -------------------------------------------------------------------------------
//	textShouldEndEditing:
// -------------------------------------------------------------------------------
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
	if ([[fieldEditor string] length] == 0)
	{
		// don't allow empty node names
		return NO;
	}
	else
	{
		return YES;
	}
}

// -------------------------------------------------------------------------------
//	shouldEditTableColumn:tableColumn:item
//
//	Decide to allow the edit of the given outline view "item".
// -------------------------------------------------------------------------------
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	BOOL result = YES;
	
	item = [item representedObject];
	if ([self isSpecialGroup:item])
	{
		result = NO; // don't allow special group nodes to be renamed
	}
	else
	{
		if ([[item urlString] isAbsolutePath])
			result = NO;	// don't allow file system objects to be renamed
	}
	
	return result;
}

// -------------------------------------------------------------------------------
//	outlineView:willDisplayCell
// -------------------------------------------------------------------------------
- (void)outlineView:(NSOutlineView *)olv willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{	 
	if ([[tableColumn identifier] isEqualToString:COLUMNID_NAME])
	{
		// we are displaying the single and only column
		if ([cell isKindOfClass:[ImageAndTextCell class]])
		{
			item = [item representedObject];
			if (item)
			{
				if ([item isLeaf])
				{
					// does it have a URL string?
					NSString *urlStr = [item urlString];
					if (urlStr)
					{
						if ([item isLeaf])
						{
							NSImage *iconImage;
							iconImage = [[NSWorkspace sharedWorkspace] iconForFile:urlStr];
							[item setNodeIcon:iconImage];
						}
						else
						{
							NSImage* iconImage = [[NSWorkspace sharedWorkspace] iconForFile:urlStr];
							[item setNodeIcon:iconImage];
						}
					}
					else
					{
						// it's a separator, don't bother with the icon
					}
				}
				else
				{
					// check if it's a special folder (DEVICES or PLACES), we don't want it to have an icon
					if ([self isSpecialGroup:item])
					{
						[item setNodeIcon:nil];
					}
					else
					{
						// it's a folder, use the folderImage as its icon
						[item setNodeIcon:folderImage];
					}
				}
			}
			
			// set the cell's image
			[(ImageAndTextCell*)cell setImage:[item nodeIcon]];
		}
	}
}

// -------------------------------------------------------------------------------
//	removeSubview:
// -------------------------------------------------------------------------------
- (void)removeSubview
{
	// empty selection
	NSArray *subViews = [placeHolderView subviews];
	if ([subViews count] > 0)
	{
		[[subViews objectAtIndex:0] removeFromSuperview];
	}
	
	[placeHolderView displayIfNeeded];	// we want the removed views to disappear right away
}

// -------------------------------------------------------------------------------
//	changeItemView:
// ------------------------------------------------------------------------------
- (void)changeItemView
{
	NSArray		*selection = [treeController selectedNodes];	
	BaseNode	*node = [[selection objectAtIndex:0] representedObject];
	NSString	*urlStr = [node urlString];
	
	if (urlStr)
	{
		NSURL *targetURL = [NSURL fileURLWithPath:urlStr];
		
		if ([urlStr hasPrefix:HTTP_PREFIX])
		{
			// Webview would go here... lets skip this for now, we are using workbench types
		
		}
		else
		{
			// Fileview would go here, again, lets skip this for now we are using workbench views
		}
		
		NSRect newBounds;
		newBounds.origin.x = 0;
		newBounds.origin.y = 0;
		newBounds.size.width = [[currentView superview] frame].size.width;
		newBounds.size.height = [[currentView superview] frame].size.height;
		[currentView setFrame:[[currentView superview] frame]];
		
		// make sure our added subview is placed and resizes correctly
		[currentView setFrameOrigin:NSMakePoint(0,0)];
		[currentView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	}
	else
	{
		// there's no url associated with this node
		// so a container was selected - no view to display
		//[self removeSubview];
		//currentView = nil;
	}
}

// -------------------------------------------------------------------------------
//	outlineViewSelectionDidChange:notification
// -------------------------------------------------------------------------------
- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	if (buildingOutlineView)	// we are currently building the outline view, don't change any view selections
		return;
	
	// ask the tree controller for the current selection
	NSIndexPath *path = [treeController selectionIndexPath];
	[document selectionDidChange:[document objectAtIndexPath:path]];

	
	NSLog(@"Did select item, pass selection on to object");
}

// ----------------------------------------------------------------------------------------
// outlineView:isGroupItem:item
// ----------------------------------------------------------------------------------------
-(BOOL)outlineView:(NSOutlineView*)outlineView isGroupItem:(id)item
{
	if ([self isSpecialGroup:[item representedObject]])
	{
		return YES;
	}
	else
	{
		return NO;
	}
}





#pragma mark -
#pragma mark Split View Delegate

// -------------------------------------------------------------------------------
//	splitView:constrainMinCoordinate:
//
//	What you really have to do to set the minimum size of both subviews to kMinOutlineViewSplit points.
// -------------------------------------------------------------------------------
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedCoordinate ofSubviewAt:(int)index
{
	return proposedCoordinate + kMinOutlineViewSplit;
}

// -------------------------------------------------------------------------------
//	splitView:constrainMaxCoordinate:
// -------------------------------------------------------------------------------
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedCoordinate ofSubviewAt:(int)index
{
	return proposedCoordinate - kMinOutlineViewSplit;
}

// -------------------------------------------------------------------------------
//	splitView:resizeSubviewsWithOldSize:
//
//	Keep the left split pane from resizing as the user moves the divider line.
// -------------------------------------------------------------------------------
- (void)splitView:(NSSplitView*)sender resizeSubviewsWithOldSize:(NSSize)oldSize
{
	NSRect newFrame = [sender frame]; // get the new size of the whole splitView
	NSView *left = [[sender subviews] objectAtIndex:0];
	NSRect leftFrame = [left frame];
	NSView *right = [[sender subviews] objectAtIndex:1];
	NSRect rightFrame = [right frame];
	
	CGFloat dividerThickness = [sender dividerThickness];
	
	leftFrame.size.height = newFrame.size.height;
	
	rightFrame.size.width = newFrame.size.width - leftFrame.size.width - dividerThickness;
	rightFrame.size.height = newFrame.size.height;
	rightFrame.origin.x = leftFrame.size.width + dividerThickness;
	
	[left setFrame:leftFrame];
	[right setFrame:rightFrame];
}






#pragma mark -
#pragma mark ToolBar Item Delegate

// -------------------------------------------------------------------------------
//	addPhysicsGroup:(id)sender
// -------------------------------------------------------------------------------
- (IBAction) addPhysicsGroup:(id)sender {
	// Force selection to begin with default group (version 1.0)	
	NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:0];
	[treeController setSelectionIndexPath:indexPath];
	
	// Index path added for child folder
	indexPath = [indexPath indexPathByAddingIndex:[[document physicsGroups] count]  ];
	
	
	// create a leaf node
	NSString *title = [document createNewPhysicsGroup:nil];
	PhysicsGroup *group = [[PhysicsGroup alloc] init];
	
	ChildNode *node = [[ChildNode alloc] init];
	[node setNodeTitle:title];
    [node setContents:group];
	
	// the user is adding a child node, tell the controller directly
	[document insertObject:node atArrangedObjectIndexPath:indexPath];
	
	[node release];
	
}

#pragma mark -
#pragma mark Menu Delegate
// -------------------------------------------------------------------------------
//	menuItemResponder:
// -------------------------------------------------------------------------------
- (void) menuItemResponder:(id)sender {
	
	
	//PhysicsGrid *grid = (PhysicsGrid*) [[placeHolderView subviews] lastObject];
	//GraphicsCocos2dAppDelegate *delegate = (GraphicsCocos2dAppDelegate*) [[NSApplication sharedApplication] delegate];
	//NSArray *array = delegate.document.physicsGroups;
	
	//[grid renderGroupToScreen:[array lastObject]];
	
	// If we've rendered to the screen add object to screen
	//[self addNodeToDocument:item.title withName:nil];
	
	// Add to document based on rules
	// If we do not have a selection, add to our default group
	
	NSMenuItem *item = (NSMenuItem*) sender;
	TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithURL:nil withName:item.title selectItsParent:YES withType:NODE];
	[self addObjectToTree:treeObjInfo];
}



// -------------------------------------------------------------------------------
//	populateMenu:
// -------------------------------------------------------------------------------
- (void) populateMenu 
{
	// Lets go ahead and update the shapes menu
	FrameworkManager *sharedMgr = [FrameworkManager sharedFrameworkManager];
	NSArray *shapes = {[sharedMgr fetchStringsOfShapesTypes]};
	NSString *name;
	for (name in shapes) {
		NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:name action:@selector(menuItemResponder:) keyEquivalent:@""];
		
		// Unfortunantely we need to create a call back to the shared manager
		// to hook menu items to framework, this is very strict coupling and presents
		// a major issue since we are creating multiple points of failure
		
		[menuItem setEnabled:YES];
		[shapesMenu addItem:menuItem];
		[menuItem release];
		
	}
}


#pragma mark -
#pragma mark Document Delegate

// -------------------------------------------------------------------------------
// addPhysicsFolder:
// Buffer for multi-threading
// -------------------------------------------------------------------------------
- (void) addObjectToTree:(TreeAdditionObj*)treeObjInfo 
{
	
	if (buildingOutlineView)
	{
		switch (treeObjInfo.type) {
			case FOLDER:
				// add the folder to the tree controller, but on the main thread to avoid lock ups
				[self performSelectorOnMainThread:@selector(performAddPhyFolder:) withObject:treeObjInfo waitUntilDone:YES];
				break;
			case NODE:
				// 
				[self performSelectorOnMainThread:@selector(performAddPhyNode:) withObject:treeObjInfo waitUntilDone:YES];
				break;
			default:
				break;
		}
		
	}
	else
	{
		switch (treeObjInfo.type) {
			case FOLDER:
				// add the folder to the tree controller, but on the main thread to avoid lock ups
				[self performAddPhyFolder:treeObjInfo];
				break;
			case NODE:
				// 
				[self performAddPhyNode:treeObjInfo];
				break;
			default:
				break;
		}
	}
	
	[treeObjInfo release];
}


- (void) performAddPhyFolder:(TreeAdditionObj*) treeObjInfo 
{
	NSIndexPath *indexPath = treeObjInfo.indexPath;
	[treeController setSelectionIndexPath:treeObjInfo.indexPath];
	
	// create a leaf node
	NSString *title = treeObjInfo.nodeName;
	PhysicsGroup *group = [[PhysicsGroup alloc] init];
	
	ChildNode *node = [[ChildNode alloc] init];
	[node setNodeTitle:title];
    [node setContents:group];
	
	// the user is adding a child node, tell the controller directly
	[document insertObject:node atArrangedObjectIndexPath:indexPath];
	
	[node release];	
}


- (void) performAddPhyNode:(TreeAdditionObj*) treeObjInfo 
{
	// Create framework object type
	
	PhysicsObject *pObj = [[FrameworkManager sharedFrameworkManager] initObjectWithKey:treeObjInfo.nodeName];
	
	// Create child in parent
	ChildNode *node = [[ChildNode alloc] initLeaf];
	[node setContents:pObj];
	[node setNodeTitle:treeObjInfo.nodeName];
	
	
	
	NSIndexPath *indexPath;
	NSUInteger default_path[] = {0, 0};
	// Check to see if we are attempting to perform logic on root controller
	if ( [[treeController selectedObjects] count] == 0  ) {
		NSLog(@"setting to default path");
		
		indexPath = [NSIndexPath indexPathWithIndexes:default_path length:2];
		[treeController setSelectionIndexPath:indexPath];
	}
	
	// If we have a selection but it's a leaf, we want the default group
	if ([[treeController selectedObjects] count] > 0)
	{
		// we have a selection
		if ([[[treeController selectedObjects] objectAtIndex:0] isLeaf])
		{
			// trying to add a child to a selected leaf node, so select its parent for add
			//indexPath = [NSIndexPath indexPathWithIndex:0];
			//[treeController setSelectionIndexPath:indexPath];
			[self selectParentFromSelection];
		}
	}
	
	// If we do have a selection, add to that group
	if ([[treeController selectedObjects] count] > 0)
	{
		
		NSIndexPath *treePath = [treeController selectionIndexPath];
		// Someone tried selecting the root controller this time
		if ( [treePath length] == 1 && ([treePath indexAtPosition:0] == 0) ) {
			NSLog(@"setting to default path");
			indexPath = [NSIndexPath indexPathWithIndexes:default_path length:2];
			[treeController setSelectionIndexPath:indexPath];
		}
		
		// we have a selection, insert at the end of the selection
		indexPath = [treeController selectionIndexPath];
		indexPath = [indexPath indexPathByAddingIndex:[[[[treeController selectedObjects] objectAtIndex:0] children] count]];
	}
	
	// Document should notify anyone listening that it's updated
	[document insertObject:node atArrangedObjectIndexPath:indexPath];
	
}
*/
@end
