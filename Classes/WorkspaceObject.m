//
//  WorkspaceObject.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/11/10.
//  Copyright (c) 2010 Personal. All rights reserved.
//

#import "WorkspaceObject.h"


@implementation WorkspaceObject

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
        isVisible = YES;
		isSelected = NO;
        isEditing = NO;
    }
    
    return self;
}

- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

- (BOOL) isEditing {
    return isEditing;
}

- (void) setIsEditing:(BOOL)newIsEditing {
    isEditing = newIsEditing;
}

- (BOOL) isSelected {
    return isSelected;
}

- (void) setIsSelected:(BOOL)newIsSelected {
    isSelected = newIsSelected;
}

- (BOOL) isVisible {
    return isVisible;
}

- (void) setIsVisible:(BOOL)newIsVisible {
    isVisible = newIsVisible;
}

/**
 * Allows a standard mechanism to draw all content displayed within our grids
 *
 * Must be sub-classed
 */
-(void) drawContentInContext:(CGContextRef)ctx {
    
    // Short circuit after this
    // for decreased render time
    if ( !isVisible )  {
        self.opacity = 0.0;
        return ;
    }
    
    // Draw selection marquee
    if ( isSelected ) {
        // draw selection
        [self drawPerimeter];
    }
    
    // Draws object to layer
    [self drawContentInWorkspaceContext:ctx];
    
}


/**
 * Sub-classes should use this method, this allows workspace objects to provide all
 * upfront rendering for free. This will use the standard marquee and visibility techniques
 *
 */
- (void) drawContentInWorkspaceContext:(CGContextRef)ctx {
    [NSException raise:NSInternalInconsistencyException 
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

/**
 *
 *
 */
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
