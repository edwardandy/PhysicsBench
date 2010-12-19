//
//  PhysicsGroup.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/1/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "PhysicsGroup.h"
#import "PhysicsObject.h"

@implementation PhysicsGroup

@synthesize physicsObjects, currentObject;

// -------------------------------------------------------------------------------
//	init
//
//	Provide document standard properties on initialization
// -------------------------------------------------------------------------------
- (id) init
{
	self = [super init];
	if (self != nil) {
		physicsObjects = [[NSMutableArray alloc] init];
		currentObject  = [[PhysicsObject alloc] init]; 	
	}
	return self;
}

// -------------------------------------------------------------------------------
//	dealloc
//
//	Yes, it's all about memory management!
// -------------------------------------------------------------------------------
- (void) dealloc
{
	[physicsObjects release];
	[currentObject release];
	[super dealloc];
}


@end
