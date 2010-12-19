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
#import "ImageAndTextCell.h"
#import "SeparatorCell.h"
#import "DocNode.h"
#import "PhysicsObject.h"
#import "EmptyObject.h"
#import "FrameworkManager.h"
#import "MyWindowController.h"
#import "NSTreeController+Extensions.h"

#define COLUMNID_NAME			@"NameColumn"	// the single column name in our outline view

// Private Class
@interface TreeController (PrivateController)
- (void)populateOutlineContents:(id)inObject;
@end


// Public Class
@implementation TreeController

@synthesize document, treeController;

/**
 *	initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 */
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

/**
 * Init with this particular nib
 */
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withController:(NSTreeController*)controller {
	treeController = controller;
	return [self initWithNibName:@"TreeOutlineView" bundle:nil];
}

/**
 *	initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 */
- (void) dealloc
{
	// Handle Deallocations
	[folderImage release];
	[contents release];
	[super dealloc];
}



#pragma mark -
#pragma mark NSViewController

/**
 *	awakeFromNib
 */
- (void)awakeFromNib 
{
	GraphicsCocos2dAppDelegate *delegate = [[NSApplication sharedApplication] delegate];
	document = delegate.document;
	
	[outlineView bind:@"content" toObject:treeController withKeyPath:@"arrangedObjects" options:nil];	
	[outlineView bind:@"selectionIndexPaths" toObject:treeController withKeyPath:@"selectionIndexPaths" options:nil];		
	[tableOutletColumn bind:@"value" toObject:treeController withKeyPath:@"arrangedObjects.nodeTitle" options:nil];
	
	[self populateOutlineContents:self];

}

/**
 *	populateOutlineContents:inObject
 *
 *	This method is being called on a separate thread to avoid blocking the UI
 *	a startup time.
 */
- (void)populateOutlineContents:(id)inObject 
{
	
	[outlineView setHidden:YES];	// hide the outline view - don't show it as we are building the contents
	
	// insert the "Devices" group at the top of our tree
	
	// Force selection to begin with default group (version 1.0)
	NSString *title = @"DEFAULT";
    
    PhysicsObject *obj = [[EmptyObject alloc] init];
    DocNode *node = [[DocNode alloc] init];
    [node setNodeTitle:title];
    [node setContents:obj];
    [node setNodeIcon:nil];
    
    [treeController insertObject:node];
	
	[outlineView setHidden:NO];	// we are done populating the outline view content, show it again
}


#pragma mark -
#pragma mark NSOutlineView delegate


// -------------------------------------------------------------------------------
//	shouldSelectItem:item
// -------------------------------------------------------------------------------
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item;
{
    // Notify the object that they have been selected
    DocNode * node = [item representedObject];
    if ( nil != node.contents) {
        node.contents.isSelected = YES;
    }

    return true;
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
		DocNode* node = [item representedObject];
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
	return YES;
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
                    // it's a folder, use the folderImage as its icon
                    [item setNodeIcon:folderImage];

				}
			}
			
			// set the cell's image
			[(ImageAndTextCell*)cell setImage:[item nodeIcon]];
		}
	}
}

// ----------------------------------------------------------------------------------------
// outlineView:isGroupItem:item
// ----------------------------------------------------------------------------------------
-(BOOL)outlineView:(NSOutlineView*)outlineView isGroupItem:(id)item
{
	return NO;
}


@end
