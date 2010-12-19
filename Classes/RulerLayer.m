//
//  RulerLayer.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/6/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "RulerLayer.h"

@interface RulerLayer (PrivateMethods)
- (void) drawRulerLayer;
@end

@implementation RulerLayer


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
	
	[self drawRulerLayer];
	
	CGContextRestoreGState(myContext);
	CGContextSetAllowsAntialiasing(myContext, YES);
	CGContextSetShouldAntialias(myContext, YES);
	
	[NSGraphicsContext restoreGraphicsState];
	
}


// -------------------------------------------------------------------------------
//	drawRulerLayer
//
// This will provide a our ruler layer that will coordinate the drawing to actual values,
// we needs to ensure that we are using the correct unit of measurement based on the 
// framework type. For example box2d is represented as MKS. 
// -------------------------------------------------------------------------------
- (void) drawRulerLayer {	
	
	
	// Draw wide ruler
	float height = 20.0f;
	CGFloat maxY = NSMaxY(NSRectFromCGRect(self.frame));
	
	NSSize originalSize = {self.frame.size.width, self.frame.size.height};
	//NSPoint frameOrigin = {self.frame.origin.x + 5.0f, self.frame.origin.y +8.0f};
	NSRect rect = 	NSMakeRect(0.0f , maxY-1.0f, originalSize.width-5.0f , -height);	
	
	// Begin outlining our path
	NSBezierPath * path;
	path = [NSBezierPath bezierPathWithRect:rect];
	
	[[NSColor colorWithDeviceRed:0.97 green:0.97 blue:0.97 alpha:1.0] set];
	[path fill];
	
	[path setLineWidth:1];
	[[NSColor darkGrayColor] set];
	[path stroke];
	
	
	// Draw x marks
	NSBezierPath *line = [NSBezierPath bezierPath];
	int lines = 35;
	float space = (originalSize.width-5.0f) / lines;
	//int minorLine = maxY / lines;
	for (int i = 0; i < lines; i++ ) {
		NSPoint penStart = {0.0f + (space*i), maxY-height+5.0f};
		NSPoint penEnd = {0.0f + (space*i), maxY-height};		
		
		
		[line moveToPoint:penStart];
		[line lineToPoint:penEnd];
		[line stroke];
	}
	
	
	// Draw tall ruler
	rect = 	NSMakeRect(0.0f , 0.0f, height , originalSize.height-1.0f);
	path = [NSBezierPath bezierPathWithRect:rect];
	[[NSColor colorWithDeviceRed:0.97 green:0.97 blue:0.97 alpha:1.0] set];
	[path fill];
	
	// Begin outlining our path
	[path setLineWidth:1];
	[[NSColor darkGrayColor] set];
	[path stroke];
	
	// Draw x marks
	for (int i = 0; i < lines; i++ ) {
		NSPoint penStart = {height, 0.0f + (space*i)};
		NSPoint penEnd = {height-5.0f, 0.0f + (space*i)};		
		
		[line moveToPoint:penStart];
		[line lineToPoint:penEnd];
		[line stroke];
	}
}


@end
