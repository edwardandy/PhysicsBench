//
//  Document.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/1/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

#define DEFAULT_PATH	0
#define ROOT_PATH_COUNT 1

@class PhysicsObject;

@interface Document : NSDocument {
	
@public
	// Meta-Data 
	NSString			*title;
	NSDate				*created;
	NSString			*owner;
	
	// Contains a listing of all the physics data
	NSArray				*physicsGroups;
	NSTreeController	*treeController;
			
	// Hide our mutable physics group
	NSMutableArray		*m_physicsGroups;

    CALayer             *rootLayer; 
}

//********************* Properties ******************

@property (nonatomic, retain) CALayer               *rootLayer; 
@property (nonatomic, retain) NSString				*title;
@property (nonatomic, retain) NSDate				*created;
@property (nonatomic, retain) NSString				*owner;
@property (nonatomic, copy)   NSArray				*physicsGroups;
@property (nonatomic, retain) NSTreeController		*treeController;
@property (nonatomic, retain) NSMutableArray		*m_physicsGroups;

//********************* Methods  ********************


@end


@interface Document (EventHandling)

- (void) selectionDidChange:(id)object;

@end


extern NSString * DocumentDidUpdatePhysicsGroup;
