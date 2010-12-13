//
//  MyWindowController.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/7/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@class TreeController, GCTabController, Document;

@interface MyWindowController : NSWindowController {

@public
    IBOutlet NSView				*leftView;
	IBOutlet NSView				*middleView;
	IBOutlet NSView				*rightView;
	IBOutlet NSMenu				*shapesMenu;
	IBOutlet NSTreeController	*outlineController;

   	
@private
	TreeController		*treeController;
    GCTabController     *tabController;
	Document			*document;
}


@property (nonatomic, retain) IBOutlet NSTreeController *outlineController;
@property (nonatomic, assign)  Document *document;

- (IBAction) addPhysicsGroup:(id)sender;

@end
