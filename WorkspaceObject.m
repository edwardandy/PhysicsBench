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
		isSelected = YES;
    }
    
    return self;
}

- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

- (void) setIsEditing:(BOOL)newIsEditing {
    isEditing = newIsEditing;
    [self setNeedsDisplay];
}

- (void) setIsSelected:(BOOL)newIsSelected {
    isSelected = newIsSelected;
    [self setNeedsDisplay];
}

- (void) setIsVisible:(BOOL)newIsVisible {
    isVisible = newIsVisible;
    [self setNeedsDisplay];    
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


@end
