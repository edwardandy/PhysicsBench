//
//  GridDrawObject.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/11/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "GridDrawObject.h"

@interface GridDrawObject (PrivateMethods)

- (void) performDraw;
- (void) drawPerimeter;


@end



@implementation GridDrawObject

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.masksToBounds = YES;
		
	}
	return self;
}


- (void) setIsSelected:(BOOL) value; {
	isSelected = value;	
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
	
	[self performDraw];
	
	CGContextRestoreGState(myContext);
	CGContextSetAllowsAntialiasing(myContext, YES);
	CGContextSetShouldAntialias(myContext, YES);
	
	[NSGraphicsContext restoreGraphicsState];
	
}


// -------------------------------------------------------------------------------
// performDraw
//
// CALayer Subclass implementation for video memory back drawing within 
// video card supported context
// -------------------------------------------------------------------------------
- (void) performDraw {
	[self drawPerimeter];
	
	

}


- (void) drawPerimeter {
	CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];
	
	if ( !isSelected ) {

		CGRect newrect = self.bounds;
		//CGRectApplyAffineTransform(self.bounds,  CGAffineTransformMakeScale(1.0, 1.0));
		//CGPoint newpoint = CGPointApplyAffineTransform(newrect.origin, CGAffineTransformMakeTranslation(0.0, 0.0));

		
		// Inner Path
		
		NSRect cornerrect = NSInsetRect(NSMakeRect(newrect.origin.x, newrect.origin.y, newrect.size.width, newrect.size.height), 3.0, 3.0);
		NSBezierPath *innerPath = [NSBezierPath bezierPathWithRoundedRect:cornerrect xRadius:2.0 yRadius:2.0];
		CGContextSetStrokeColorWithColor(myContext, CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0));
		CGContextSetFillColorWithColor(myContext, CGColorCreateGenericRGB(0.5, 0.7, 0.7, 0.08));
		
		[innerPath setLineWidth:1.0];
		[innerPath stroke];	
		[innerPath fill];
		
		
		// Outer Path
		
		
		 cornerrect = NSInsetRect(NSMakeRect(newrect.origin.x, newrect.origin.y, newrect.size.width, newrect.size.height), 0.9, 0.9);
		
		NSBezierPath *outerPath = [NSBezierPath bezierPathWithRoundedRect:cornerrect xRadius:2.0 yRadius:2.0];
		CGContextSetStrokeColorWithColor(myContext, CGColorCreateGenericRGB(0.596, 0.596, 0.596, 0.8));
		CGContextSetFillColorWithColor(myContext, CGColorCreateGenericRGB(0.5, 0.7, 0.7, 1.0));

		[outerPath setLineWidth:1.0];
		[outerPath stroke];	
		

	} else {
		
		CGRect newrect = self.bounds;
		//CGRectApplyAffineTransform(self.bounds,  CGAffineTransformMakeScale(1.0, 1.0));
		//CGPoint newpoint = CGPointApplyAffineTransform(newrect.origin, CGAffineTransformMakeTranslation(0.0, 0.0));
		
		
		// Inner Path
		
		NSRect cornerrect = NSInsetRect(NSMakeRect(newrect.origin.x, newrect.origin.y, newrect.size.width, newrect.size.height), 4.0, 4.0);
		NSBezierPath *innerPath = [NSBezierPath bezierPathWithRoundedRect:cornerrect xRadius:2.0 yRadius:2.0];
		CGContextSetStrokeColorWithColor(myContext, CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0));
		CGContextSetFillColorWithColor(myContext, CGColorCreateGenericRGB(0.5, 0.7, 0.7, 0.08));
		
		[innerPath setLineWidth:1.0];
		[innerPath stroke];	
		[innerPath fill];
		
		
		// Outer Path
		
		
		cornerrect = NSInsetRect(NSMakeRect(newrect.origin.x, newrect.origin.y, newrect.size.width, newrect.size.height), 0.9, 0.9);
		
		NSBezierPath *outerPath = [NSBezierPath bezierPathWithRoundedRect:cornerrect xRadius:3.0 yRadius:3.0];
		CGContextSetStrokeColorWithColor(myContext, CGColorCreateGenericRGB(0.0, 0.4705, 0.988, 1.0));
		CGContextSetFillColorWithColor(myContext, CGColorCreateGenericRGB(0.5, 0.7, 0.7, 1.0));
		

		[outerPath setLineWidth:1.2];
		[outerPath stroke];	
		
	}
	
	
	
	
}


@end
