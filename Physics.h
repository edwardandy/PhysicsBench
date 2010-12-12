//
//  PhysicsObject.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 8/26/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Workbench.h"

@class PhysicsObject, FrameworkDefinition;

/*****************************************
/* Regardless of physics engine type we are going
/* to ask each renderable to conform to the following standard.
/* This ensures we are using the appropriate display loop.
/*****************************************/ 
@protocol PhysicsRenderable <RenderLayer>

@required
	- (void) simulateRenderObject;
	- (void) glRenderObject;
@end



/*****************************************
 /* Regardless of physics engine type we are going
 /* to attempt to define high-level methods that each
 /* one should respond to. Otherwise we are handling by
 /* by key-value coding
 /*****************************************/
@protocol Physics2dFramework

@required
	// Force our frameworks to initialize a defintion
	FrameworkDefinition *definition;
	@property (readonly) FrameworkDefinition *definition;

	// Methods for our Physics2d framework
	- (NSArray *)	fetchStringsOfShapesTypes; 
	- (PhysicsObject *) initObjectWithKey:(NSString*)key;
	- (void) createObjectWithKey:(NSString*)key;
	- (void) createObjectWithKey:(NSString*)key inGroup:(id)group;
@end


/****************************************
/* 
/***************************************/
@protocol Physics2dObject

@required
    - (NSArray*) doesConformToFrameworkClasses;	
@end