//
//  BaseDrawableObject.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/10/10.
//  Copyright (c) 2010 Personal. All rights reserved.
//

#import "BaseDrawableObject.h"

@implementation BaseDrawableObject

@synthesize     objName,needsRender,d_size, d_origin;

/**
 * Default Initializer
 */
- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
        objName = @"";
        d_size = NSZeroSize;
        d_origin = NSZeroPoint;
        needsRender = YES;

        self.delegate = self;
        self.frame = CGRectMake(200.0, 200.0, 200.0, 200.0);
         
    }
    
    return self;
}

/**
 * Default memory-management for garbage collection
 */
- (void)dealloc {
    // Clean-up code here.
    [objName release];
    [super dealloc];
}

#pragma mark -
#pragma mark RenderLayer

/**
 * Implements a CALayer delegate. Allows our
 * layers to be video memory backed rather than
 * redrawing per pixel
 */
- (void)drawInContext:(CGContextRef)ctx {
    [NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO]];
	
	// draw something
	CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(myContext);
	CGContextSetAllowsAntialiasing(myContext, NO);
	CGContextSetShouldAntialias(myContext, NO);
    
    [self willDrawContentInContext:ctx];
	[self drawContentInContext:ctx];
    [self didDrawContentInContext:ctx];
	
	CGContextRestoreGState(myContext);
	CGContextSetAllowsAntialiasing(myContext, YES);
	CGContextSetShouldAntialias(myContext, YES);
	
	[NSGraphicsContext restoreGraphicsState];
    
    [self setNeedsRender:NO];
}

/**
 * Allows a standard mechanism to draw all content displayed within our grids
 *
 * Must be sub-classed
 */
-(void) drawContentInContext:(CGContextRef)ctx {
    [NSException raise:NSInternalInconsistencyException 
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

/**
 * Notification that drawing will occur
 */
- (void) willDrawContentInContext:(CGContextRef)ctx {
}

/**
 * Notification that drawing occured
 */
- (void) didDrawContentInContext:(CGContextRef)ctx{
}

@end
