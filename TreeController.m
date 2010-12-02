//
//  TreeController.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/7/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "TreeController.h"
#import "GraphicsCocos2dAppDelegate.h"
#import "Document.h"
#import "BaseNode.h"
#import "ImageAndTextCell.h"
#import "SeparatorCell.h"
#import "ChildNode.h"
#import "PhysicsGroup.h"
#import "FrameworkManager.h"
#import "MyWindowController.h"

#define COLUMNID_NAME			@"NameColumn"	// the single column name in our outline view
#define PHYSICS_NAME			@"PHYSICS"


// ******************************************************************************

@implementation TreeAdditionObj
@synthesize indexPath, nodeURL, nodeName, selectItsParent, type, content;

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

@interface TreeController (PrivateMethods)
- (void)populateOutlineContents:(id)inObject;
- (void)selectParentFromSelection;
- (BOOL)isSpecialGroup:(BaseNode *)groupNode;
@end



// ******************************************************************************

@implementation TreeController

@synthesize document, treeController;

// -------------------------------------------------------------------------------
//	initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
// -------------------------------------------------------------------------------
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self != nil) {
		// Handle our real initializations
		
		// Cache our folder image
		folderImage = [[[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)] retain];
		[folderImage setSize:NSMakeSize(16,16)];
		
		// Fill our contents
		contents = [[NSMutableArray alloc] init];
			
		
	}
	return self;
}


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withController:(NSTreeController*)controller {
	treeController = controller;
	return [self initWithNibName:@"TreeOutlineView" bundle:nil];
}

// -------------------------------------------------------------------------------
//	initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
// -------------------------------------------------------------------------------
- (void) dealloc
{
	// Handle Deallocations
	[folderImage release];
	[contents release];
	[super dealloc];
}



#pragma mark -
#pragma mark NSViewController

// -------------------------------------------------------------------------------
//	awakeFromNib
// -------------------------------------------------------------------------------
- (void)awakeFromNib 
{
	GraphicsCocos2dAppDelegate *delegate = [[NSApplication sharedApplication] delegate];
	document = delegate.document;
	
	[outlineView bind:@"content" toObject:treeController withKeyPath:@"arrangedObjects" options:nil];	
	[outlineView bind:@"selectionIndexPaths" toObject:treeController withKeyPath:@"selectionIndexPaths" options:nil];		
	[tableColumn bind:@"value" toObject:treeController withKeyPath:@"arrangedObjects.nodeTitle" options:nil];
	
	[self populateOutlineContents:self];

}


#pragma mark -
#pragma mark NSOutlineView delegate




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
//	outlineViewSelectionDidChange:notification
// -------------------------------------------------------------------------------
- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	if (buildingOutlineView)	// we are currently building the outline view, don't change any view selections
		return;
	
	// ask the tree controller for the current selection
	
	NSIndexPath *path = [treeController selectionIndexPath];
	
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
#pragma mark Delegate

// -------------------------------------------------------------------------------
//	isSpecialGroup:
// -------------------------------------------------------------------------------
- (BOOL)isSpecialGroup:(BaseNode *)groupNode
{ 
	return ([groupNode nodeIcon] == nil &&
			[[groupNode nodeTitle] isEqualToString:PHYSICS_NAME] );
}

// -------------------------------------------------------------------------------
//	populateOutlineContents:inObject
//
//	This method is being called on a separate thread to avoid blocking the UI
//	a startup time.
// -------------------------------------------------------------------------------
- (void)populateOutlineContents:(id)inObject 
{
	
	[outlineView setHidden:YES];	// hide the outline view - don't show it as we are building the contents
	
	// insert the "Devices" group at the top of our tree
	
	// Force selection to begin with default group (version 1.0)
	NSString *title = @"DEFAULT";
	[self addFolder:title];
	
	// remove the current selection
	NSArray *selection = [treeController selectionIndexPaths];
	[treeController removeSelectionIndexPaths:selection];
	
	[outlineView setHidden:NO];	// we are done populating the outline view content, show it again
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
		indexPath = [NSIndexPath indexPathWithIndex:[[treeController arrangedObjects] count]];
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
    [node setContents:treeAddition.content];
	
	// the user is adding a child node, tell the controller directly
	[treeController insertObject:node atArrangedObjectIndexPath:indexPath];
	
	[node release];
}


// -------------------------------------------------------------------------------
//	performAddChild:treeAddition
// -------------------------------------------------------------------------------
-(void)performAddChild:(TreeAdditionObj *)treeAddition
{
    // 
    
	if ( [[treeController selectedObjects] count] == 0 ) {
		[treeController setSelectionIndexPath:[NSIndexPath indexPathWithIndex:0]];	
	}
	
	
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
		indexPath = [NSIndexPath indexPathWithIndex:[[document m_physicsGroups]count]];
	}
	
	// create a leaf node
	ChildNode *node = [[ChildNode alloc] initLeaf];
	[node setURL:[treeAddition nodeURL]];
	[node setContents:treeAddition.content];
	
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
			[node setNodeTitle:treeAddition.nodeName];
			[node setURL:treeAddition.nodeName];
		}
	}
	
	// the user is adding a child node, tell the controller directly
	[treeController insertObject:node atArrangedObjectIndexPath:indexPath];
	
	[node release];
	
	// adding a child automatically becomes selected by NSOutlineView, so keep its parent selected
	if ([treeAddition selectItsParent])
		[self selectParentFromSelection];
}

// -------------------------------------------------------------------------------
//	addFolder:folderName:
// -------------------------------------------------------------------------------
- (void)addFolder:(NSString *)folderName withContents:(id)content
{
	TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithURL:nil withName:folderName selectItsParent:NO];
	treeObjInfo.content = content;

	[self performAddFolder:treeObjInfo];
	
	[treeObjInfo release];
}

// -------------------------------------------------------------------------------
//	addFolder:folderName:
// -------------------------------------------------------------------------------
- (void)addChild:(NSString *)folderName withContents:(id)content
{
	TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithURL:folderName withName:folderName selectItsParent:YES];
	treeObjInfo.content = content;
	[self performAddChild:treeObjInfo];
	
	[treeObjInfo release];
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



#pragma mark -
#pragma mark MenuResponder

- (void) addNewGroupFromMenu:(id)sender {
	// Force selection to begin with default group (version 1.0)	
	NSUInteger default_path[] = {[[treeController arrangedObjects] count]};
	NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:default_path  length:1];
	[treeController setSelectionIndexPath:indexPath];
	
	NSString *title = [NSString stringWithFormat:@"GROUP_%d",[[treeController arrangedObjects] count]];
	
	PhysicsGroup *group = [[PhysicsGroup alloc] init];
	[self addFolder:title withContents:group];
}

@end
