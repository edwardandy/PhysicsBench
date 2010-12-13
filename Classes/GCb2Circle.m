//
//  GCb2Circle.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/1/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "GCb2Circle.h"
#import "GCb2Types.h"

@implementation GCb2Circle


/**
 *	init
 *
 *	Provide document standard properties on initialization
 */
- (id) init
{
	self = [super init];
	if (self != nil) {
		radius		= 25.0f;
		d_size		= NSMakeSize(50.0f, 50.0f);
		d_origin	= NSMakePoint(50.0, 100.0);
		
	}
	return self;
}

/**
 *	dealloc
 *
 *	Yes, it's all about memory management!
 */
- (void) dealloc
{
	[super dealloc];
}


#pragma mark Drawing Routines

/**
 *	simulateRenderObject
 *
 *	Render a 2d representation of the circle within the workbench
 */
- (void) simulateRenderObject {
	
	CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(myContext);
	CGContextSetAlpha(myContext, 0.3);

	// Calculate position center
	// Get radius
	// subtract radius to position x for minx
	// subtract radius to position x for maxx
	// subtract radius to position y for miny
	// add radius to position y for maxy
	// Create rect
	
	NSRect rect = NSMakeRect(d_origin.x, d_origin.y, d_size.width, d_size.height);
	NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:rect];

	[[NSColor purpleColor] set];
	[path fill];
	
	[[NSColor blueColor] set];
	[path stroke];

	
	CGContextRestoreGState(myContext);
	CGContextSetAlpha(myContext, 1.0);
}

- (void) glRenderObject {
	
}


#pragma mark -
#pragma mark Physics2dObject protocol

/**
 * @see PhysicsObject/PhysicsObject.m
 */
- (NSArray*) doesConformToFrameworkClasses {
	return 	[NSArray arrayWithObjects:@"b2CircleShape", @"b2Shape", @"b2BodyDef", nil ];
}


@end
