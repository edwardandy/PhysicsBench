//
//  PhysicsObject.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/1/10.
//  Copyright 2010 Personal. All rights reserved.
//


#import "Physics.h"
#import "WorkspaceObject.h"

@class PhysicsGrid, Document;

/*
* Primary class definition for PhysicsObjects
* provides generic definition of the class. PhysicsObjects
* serves as the base class for all objects on screen.
*/
@interface PhysicsObject : WorkspaceObject <PhysicsRenderable, Physics2dObject> {
	@public 
        NSArray*		properties;		
}

// Convenience auto-release creation
+(PhysicsObject*) node;

@property (assign) NSArray*	properties;	

@end


