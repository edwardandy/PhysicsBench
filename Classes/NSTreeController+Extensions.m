//
//  NSTreeController+Extensions.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/16/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "NSTreeController+Extensions.h"


@implementation NSTreeController (NSTreeController_Extensions)


/* Supports object mode insertions rather than 
 * entity mode insertions. Additionally, inserts using custom logic
 */
- (void)insertObject:(id)object; {
    
    // NSTreeController inserts objects using NSIndexPath, so we need to calculate this
    NSIndexPath *indexPath = nil;
    
    // if there is no selection, we will add a new group to the end of the contents array
    if ([[self selectedObjects] count] == 0)
    {
        // there's no selection so add the folder to the top-level and at the end
        indexPath = [NSIndexPath indexPathWithIndex:[[self arrangedObjects] count]];
    }
    else
    {
        // get the index of the currently selected node, then add the number its children to the path -
        // this will give us an index which will allow us to add a node to the end of the currently selected node's children array.
        //
        indexPath = [self selectionIndexPath];
        if ([[[self selectedObjects] objectAtIndex:0] isLeaf])
        {
            // user is trying to add a folder on a selected child,
            // so deselect child and select its parent for addition
            [self selectParentFromSelection];
        }
        else
        {
            indexPath = [indexPath indexPathByAddingIndex:[[[[self selectedObjects] objectAtIndex:0] childNodes] count]];
        }
    }

    
    // the user is adding a child node, tell the controller directly
    [self insertObject:object atArrangedObjectIndexPath:indexPath];
    

}




/* Supports object mode childNodes, creating leaf elements, rather than 
 * entity mode insertions. Additionally, inserts using custom logic
 */
- (void)insertChildObject:(id)object; {
    
    if ([[self selectedObjects] count] > 0)
    {
        // we have a selection
        if ([[[self selectedObjects] objectAtIndex:0] isLeaf])
        {
            // trying to add a child to a selected leaf node, so select its parent for add
            [self selectParentFromSelection];
        }
    }
    
    // find the selection to insert our node
    NSIndexPath *indexPath;
    if ([[self selectedObjects] count] > 0)
    {
        // we have a selection, insert at the end of the selection
        indexPath = [self selectionIndexPath];
        indexPath = [indexPath indexPathByAddingIndex:[[[[self selectedObjects] objectAtIndex:0] childNodes] count]];
    }
    else
    {
        // no selection, just add the child to the end of the tree
        indexPath = [NSIndexPath indexPathWithIndex:[[self arrangedObjects] count]];
    }
    
    // the user is adding a child node, tell the controller directly
    [self insertObject:object atArrangedObjectIndexPath:indexPath];
    
}



// -------------------------------------------------------------------------------
//  selectParentFromSelection:
//
//  Take the currently selected node and select its parent.
// -------------------------------------------------------------------------------
- (void)selectParentFromSelection
{
    if ([[self selectedNodes] count] > 0)
    {
        NSTreeNode* firstSelectedNode = [[self selectedNodes] objectAtIndex:0];
        NSTreeNode* parentNode = [firstSelectedNode parentNode];
        if (parentNode)
        {
            // select the parent
            NSIndexPath* parentIndex = [parentNode indexPath];
            [self setSelectionIndexPath:parentIndex];
        }
        else
        {
            // no parent exists (we are at the top of tree), so make no selection in our outline
            NSArray* selectionIndexPaths = [self selectionIndexPaths];
            [self removeSelectionIndexPaths:selectionIndexPaths];
        }
    }
}

@end
