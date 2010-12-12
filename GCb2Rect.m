//
//  GCb2Rect.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/13/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "GCb2Rect.h"


@implementation GCb2Rect


#pragma mark Drawing Routines

// -------------------------------------------------------------------------------
//	init
//
//	Provide document standard properties on initialization
// -------------------------------------------------------------------------------
- (id) init
{
	self = [super init];
	if (self != nil) {
		size		= NSMakeSize(50.0f, 50.0f);
		position	= NSMakePoint(50.0, 100.0);
		
	}
	return self;
}


// -------------------------------------------------------------------------------
//	simulateRenderObject
//
//	Render a 2d representation of the circle within the workbench
// -------------------------------------------------------------------------------
- (void) simulateRenderObject {
	
	CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(myContext);
	CGContextSetAlpha(myContext, 0.3);
	
	// Calculate position center
	
	NSRect rect = NSMakeRect(position.x, position.y, size.width, size.height);
	NSBezierPath *path = [NSBezierPath bezierPathWithRect:rect];
	
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

- (NSArray*) doesConformToFrameworkClasses {
	return 	[NSArray arrayWithObjects:@"b2BodyDef", nil ];
}

@end
