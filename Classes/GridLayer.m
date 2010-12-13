//
//  GridLayer.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/6/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "GridLayer.h"

@interface GridLayer (Private)

- (void) drawGridLayer;

@end


@implementation GridLayer

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.opaque = YES;
	}
	return self;
}

// -------------------------------------------------------------------------------
//	drawInContext:(CGContextRef)ctx
//
// CALayer Subclass implementation for video memory back drawing within 
// video card supported context
// -------------------------------------------------------------------------------
- (void)drawInContext:(CGContextRef)ctx {
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO]];
	
	// draw something
	CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(myContext);
	CGContextSetAllowsAntialiasing(myContext, NO);
	CGContextSetShouldAntialias(myContext, NO);

	[self drawGridLayer];
	
	CGContextRestoreGState(myContext);
	CGContextSetAllowsAntialiasing(myContext, YES);
	CGContextSetShouldAntialias(myContext, YES);
	
	[NSGraphicsContext restoreGraphicsState];

	
}

// -------------------------------------------------------------------------------
//	drawGridLayer
//
// This will provide a basic grid, that is the backing. It is a physical representation of
// our logical grid that we will use for creating objects
// -------------------------------------------------------------------------------
- (void) drawGridLayer {
	// Drawing code here.
	
	
	NSSize originalSize = {self.frame.size.width, self.frame.size.height};
	NSPoint frameOrigin = {self.frame.origin.x, self.frame.origin.y };
	NSRect rect = 	NSMakeRect(frameOrigin.x , frameOrigin.y, originalSize.width, originalSize.height);
	
	
	
	NSBezierPath * path;
	path = [NSBezierPath bezierPathWithRect:rect];
	
	[path setLineWidth:1];
	[[NSColor whiteColor] set];
	[path fill];
	
	
	
	
	float minX = NSMinX(rect);
	float maxX = NSMaxX(rect);
	float minY = NSMinY(rect);
	float maxY = NSMaxY(rect);
	
	NSUInteger rows = 50;
	NSUInteger cols = 50;
	float colSpace = rect.size.width / cols;
	float rowSpace = rect.size.height / rows;
	
	
	CGFloat array[] = {2.0, 2.0};
	//[line setLineDash: array count: 2 phase: 0.0];
	
	// Draw our rows
	for ( int i = 0; i <= rows; i++ ) {
		NSBezierPath *line = [NSBezierPath bezierPath];	
		// Begin processing the outline of where our
		// lines should be drawn for the grid
		NSPoint penStart = {minX,  minY + (i*rowSpace)};
		NSPoint penEnd = {maxX, minY + (i*rowSpace)};
		
		// Create our path
		[line moveToPoint:penStart];
		[line lineToPoint:penEnd];
		//[line setLineDash: array count: 2 phase: 0.0];
		// Stroke our path
		
		
		if (i%8==0) {
			[[NSColor colorWithDeviceRed:0.509 green:0.7607 blue:1.0 alpha:0.70] set]; 
		} else {
			[[NSColor colorWithDeviceRed:0.509 green:0.7607 blue:1.0 alpha:0.25] set]; 
		}
		
		[line stroke];
	}
	
	// Draw our cols
	for ( int i = 0; i <= cols; i++ ) {
		NSBezierPath *line = [NSBezierPath bezierPath];	
		// Begin processing the outline of where our
		// lines should be drawn for the grid
		NSPoint penStart = {minX + (i*colSpace),  minY};
		NSPoint penEnd = {minX + (i*colSpace) , maxY};
		
		
		
		// Create our path
		[line moveToPoint:penStart];
		[line lineToPoint:penEnd];
		
		// Stroke our path
		if (i%8==0) {
			[[NSColor colorWithDeviceRed:0.509 green:0.7607 blue:1.0 alpha:0.70] set]; 
		} else {
			[[NSColor colorWithDeviceRed:0.509 green:0.7607 blue:1.0 alpha:0.25] set]; 
		}
		[line stroke];
	}
	
	[[NSColor grayColor] set]; 
	
	[path stroke];
	
	
}


@end
