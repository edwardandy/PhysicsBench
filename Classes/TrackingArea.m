//
//  TrackingArea.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/12/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "TrackingArea.h"


@implementation TrackingArea


- (id) init
{
	self = [super init];
	if (self != nil) {
		startPoint = NSZeroPoint;
		endPoint = NSZeroPoint;

	}
	return self;
}


- (void)drawInContext:(CGContextRef)ctx {
	NSLog(@"Drawing In Context");
	
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO]];
	
	// draw something
	CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(myContext);
	CGContextSetAllowsAntialiasing(myContext, NO);
	CGContextSetShouldAntialias(myContext, NO);
	
	[self.path stroke];
	[self.path fill];
	
	CGContextRestoreGState(myContext);
	CGContextSetAllowsAntialiasing(myContext, YES);
	CGContextSetShouldAntialias(myContext, YES);
	
	[NSGraphicsContext restoreGraphicsState];
	
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
		NSLog(@"Drawing In layer");
	
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO]];
	
	// draw something
	CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(myContext);
	CGContextSetAllowsAntialiasing(myContext, NO);
	CGContextSetShouldAntialias(myContext, NO);
	
	[self.path stroke];
	[self.path fill];
	
	CGContextRestoreGState(myContext);
	CGContextSetAllowsAntialiasing(myContext, YES);
	CGContextSetShouldAntialias(myContext, YES);
	
	[NSGraphicsContext restoreGraphicsState];
}

@end
