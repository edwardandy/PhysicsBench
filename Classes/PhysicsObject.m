//
//  PhysicsObject.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/1/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "PhysicsObject.h"
#import "PhysicsGrid.h"
#import "FrameworkManager.h"

@implementation PhysicsObject

@synthesize properties;

/**
 *	node
 *
 *	Provide a convenience method for creating physics object nodes
 */
+(PhysicsObject*) node {
	return [[[self alloc] init] autorelease];
}

/**
 *	init
 *
 *	Provide document standard properties on initialization
 */
- (id) init
{
	self = [super init];
	if (self != nil) {
        properties = [[FrameworkManager sharedFrameworkManager] bindFrameworkToClass:self];
	}
	return self;
}

/**
 * Memory-management deallocation for garbage collection
 */
- (void)dealloc {
    [properties dealloc];
    [super dealloc];
}


#pragma mark - 
#pragma mark Physics2dObject protocol

/**
 * Responds to whether or not an object is associated
 * to a framework type. 
 */
- (NSArray*) doesConformToFrameworkClasses {
	return nil;
}


#pragma mark -
#pragma mark Rendering

/**
 * Delegates the responsibility of rendering the content to the physics object 
 * rendering routines. 
 */
- (void) drawContentInWorkspaceContext:(CGContextRef)ctx {
    [self simulateRenderObject];
}

/**
 * Renders a simulation graphic of the object in 2d space on the workspace
 * relative to the user world-space
 */
- (void) simulateRenderObject {
	// abstract method
	[NSException raise:NSInternalInconsistencyException 
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

/**
 * Provides a gl rendering for use in the preview window. This will require an 
 * opengl space.
 *
 */
- (void) glRenderObject {
	// abstract method
	[NSException raise:NSInternalInconsistencyException 
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
