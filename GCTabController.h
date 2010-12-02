//
//  GCTabController.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/10/10.
//  Copyright (c) 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BaseGridView, Document;

@interface GCTabController : NSViewController {
@public	
	NSTreeController	*treeController;
    NSArrayController   *subChildren; 
    
    id                  content;
    NSArray         *selectionIndexPaths;
    Document            *document;
@private	
	BaseGridView		*grid;
	NSArray             *oldArray;

    
    
}

@property (nonatomic, assign) __weak NSArrayController *subChildren;
@property (nonatomic, retain) NSArray *oldArray;
@property (nonatomic, assign) __weak Document *document;
@property (nonatomic, retain)     NSArray         *selectionIndexPaths;
@property (nonatomic, retain)   id content;
@property (nonatomic, retain) 	BaseGridView *grid;
@property (nonatomic, assign) __weak 	NSTreeController *treeController;

- (id) initWithView:(NSView*) view controller:(NSTreeController*)tController;
- (void) performBinding;
@end
