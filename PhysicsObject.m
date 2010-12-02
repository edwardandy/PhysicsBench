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

@synthesize isVisible, properties;

// -------------------------------------------------------------------------------
//	node
//
//	Provide a convenience method for creating physics object nodes
// -------------------------------------------------------------------------------
+(PhysicsObject*) node {
	return [[[self alloc] init] autorelease];
}

// -------------------------------------------------------------------------------
//	init
//
//	Provide document standard properties on initialization
// -------------------------------------------------------------------------------
- (id) init
{
	self = [super init];
	if (self != nil) {
		position = NSMakePoint(0.0, 0.0);
		size = NSMakeSize(0.0, 0.0); // Subclasses should define this
		isVisible = YES;
		isSelected = YES;

        properties = [[FrameworkManager sharedFrameworkManager] bindFrameworkToClass:self];
	}
	return self;
}

// -------------------------------------------------------------------------------
//	dealloc
//
//	Yes, it's all about memory management!
// -------------------------------------------------------------------------------
- (void) dealloc
{
	[super dealloc];
}

#pragma mark - 
#pragma mark Physics2dObject protocol

- (NSArray*) doesConformToFrameworkClasses {
	return nil;
}


#pragma mark -
#pragma mark Rendering
- (NSRect)drawingBounds {
	/*
    float inset = -SKT_HALF_HANDLE_WIDTH;
    if ([self drawsStroke]) {
        float halfLineWidth = ([self strokeLineWidth] / 2.0) + 1.0;
        if (-halfLineWidth < inset) {
            inset = -halfLineWidth;
        }
    }
    inset += -1.0;
    return NSInsetRect([self bounds], inset, inset);
	 */
    NSRect rect = NSMakeRect(position.x, position.y, size.width, size.height);
	return rect;
}

- (void)startEditingWithEvent:(NSEvent *)event inView:(PhysicsGrid *)view {
    return;
}

- (void)endEditingInView:(PhysicsGrid *)view {
    return;
}

- (void)didChange {
    [_document invalidateGraphic:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:PhysicsGridViewSelectionDidChangeNotification object:self];
}

- (void)setBounds:(NSRect)bounds {
    if (!NSEqualRects(bounds, _bounds)) {
        if (!_gFlags.manipulatingBounds) {
            // Send the notification before and after so that observers who invalidate display in views will wind up invalidating both the original rect and the new one.
            [self didChange];
            [[[self undoManager] prepareWithInvocationTarget:self] setBounds:_bounds];
        }
        _bounds = bounds;
        if (!_gFlags.manipulatingBounds) {
            [self didChange];
        }
    }
}

- (NSRect)bounds {
    return _bounds;
}

- (NSUndoManager *)undoManager {
    return [_document undoManager];
}

//================================================================================
// Event Handling

#pragma mark -
#pragma mark Event Handling

- (BOOL)isEditable {
	return YES;	
}

- (BOOL)hitTest:(NSPoint)point isSelected:(BOOL)isSelected {
	/*if (isSelected && ([self knobUnderPoint:point] != NoKnob)) {
        return YES;
    } else {
        NSBezierPath *path = [self bezierPath];
		
        if (path) {
            if ([path containsPoint:point]) {
                return YES;
            }
        } else {
            if (NSPointInRect(point, [self bounds])) {
                return YES;
            }
        }
        return NO;
    }*/
	
}


//================================================================================
// Drawing Routines

#pragma mark -
#pragma mark Drawing Routines

- (unsigned)knobMask {
    return AllKnobsMask;
}

- (int)knobUnderPoint:(NSPoint)point {
	NSRect bounds = [self bounds];
	unsigned knobMask = [self knobMask];
	NSRect handleRect;
	
	handleRect.size.width = SKT_HANDLE_WIDTH;
	handleRect.size.height = SKT_HANDLE_WIDTH;
	
	if (knobMask & UpperLeftKnobMask) {
		handleRect.origin.x = NSMinX(bounds) - SKT_HALF_HANDLE_WIDTH;
		handleRect.origin.y = NSMinY(bounds) - SKT_HALF_HANDLE_WIDTH;
		if (NSPointInRect(point, handleRect)) {
			return UpperLeftKnob;
		}
	}
	if (knobMask & UpperMiddleKnobMask) {
		handleRect.origin.x = NSMidX(bounds) - SKT_HALF_HANDLE_WIDTH;
		handleRect.origin.y = NSMinY(bounds) - SKT_HALF_HANDLE_WIDTH;
		if (NSPointInRect(point, handleRect)) {
			return UpperMiddleKnob;
		}
	}
	if (knobMask & UpperRightKnobMask) {
		handleRect.origin.x = NSMaxX(bounds) - SKT_HALF_HANDLE_WIDTH;
		handleRect.origin.y = NSMinY(bounds) - SKT_HALF_HANDLE_WIDTH;
		if (NSPointInRect(point, handleRect)) {
			return UpperRightKnob;
		}
	}
	if (knobMask & MiddleLeftKnobMask) {
		handleRect.origin.x = NSMinX(bounds) - SKT_HALF_HANDLE_WIDTH;
		handleRect.origin.y = NSMidY(bounds) - SKT_HALF_HANDLE_WIDTH;
		if (NSPointInRect(point, handleRect)) {
			return MiddleLeftKnob;
		}
	}
	if (knobMask & MiddleRightKnobMask) {
		handleRect.origin.x = NSMaxX(bounds) - SKT_HALF_HANDLE_WIDTH;
		handleRect.origin.y = NSMidY(bounds) - SKT_HALF_HANDLE_WIDTH;
		if (NSPointInRect(point, handleRect)) {
			return MiddleRightKnob;
		}
	}
	if (knobMask & LowerLeftKnobMask) {
		handleRect.origin.x = NSMinX(bounds) - SKT_HALF_HANDLE_WIDTH;
		handleRect.origin.y = NSMaxY(bounds) - SKT_HALF_HANDLE_WIDTH;
		if (NSPointInRect(point, handleRect)) {
			return LowerLeftKnob;
		}
	}
	if (knobMask & LowerMiddleKnobMask) {
		handleRect.origin.x = NSMidX(bounds) - SKT_HALF_HANDLE_WIDTH;
		handleRect.origin.y = NSMaxY(bounds) - SKT_HALF_HANDLE_WIDTH;
		if (NSPointInRect(point, handleRect)) {
			return LowerMiddleKnob;
		}
	}
	if (knobMask & LowerRightKnobMask) {
		handleRect.origin.x = NSMaxX(bounds) - SKT_HALF_HANDLE_WIDTH;
		handleRect.origin.y = NSMaxY(bounds) - SKT_HALF_HANDLE_WIDTH;
		if (NSPointInRect(point, handleRect)) {
			return LowerRightKnob;
		}
	}
	
	return NoKnob;

}

// -------------------------------------------------------------------------------
//	simulateRenderObject
//
//	Render a 2d representation of the circle within the workbench
// -------------------------------------------------------------------------------

- (void) simulateRenderObject {
	// abstract method
	[NSException raise:NSInternalInconsistencyException 
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void) glRenderObject {
	// abstract method
	[NSException raise:NSInternalInconsistencyException 
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}
 

- (void)drawInView:(PhysicsGrid *)view isSelected:(BOOL)flag {
	
    
   // if (path) {
        /*if ([self drawsFill]) {
            [[self fillColor] set];
            [path fill];
        }
        if ([self drawsStroke]) {
            [[self strokeColor] set];
            [path stroke];
        }*/
		[self simulateRenderObject];
    //}
    if (flag) {
        [self drawHandlesInView:view];
    }
}

- (void)drawHandleAtPoint:(NSPoint)point inView:(PhysicsGrid *)view {
    NSRect handleRect;
	
    handleRect.origin.x = point.x - SKT_HALF_HANDLE_WIDTH + 1.0;
    handleRect.origin.y = point.y - SKT_HALF_HANDLE_WIDTH + 1.0;
    handleRect.size.width = SKT_HANDLE_WIDTH - 1.0;
    handleRect.size.height = SKT_HANDLE_WIDTH - 1.0;
    handleRect = [view centerScanRect:handleRect];
    [[NSColor controlDarkShadowColor] set];
    NSRectFill(handleRect);
    handleRect = NSOffsetRect(handleRect, -1.0, -1.0);
    [[NSColor knobColor] set];
    NSRectFill(handleRect);
}

- (void)drawHandlesInView:(PhysicsGrid *)view {
    NSRect bounds = [self bounds];
    unsigned knobMask = [self knobMask];
	
    if (knobMask & UpperLeftKnobMask) {
        [self drawHandleAtPoint:NSMakePoint(NSMinX(bounds), NSMinY(bounds)) inView:view];
    }
    if (knobMask & UpperMiddleKnobMask) {
        [self drawHandleAtPoint:NSMakePoint(NSMidX(bounds), NSMinY(bounds)) inView:view];
    }
    if (knobMask & UpperRightKnobMask) {
        [self drawHandleAtPoint:NSMakePoint(NSMaxX(bounds), NSMinY(bounds)) inView:view];
    }
	
    if (knobMask & MiddleLeftKnobMask) {
        [self drawHandleAtPoint:NSMakePoint(NSMinX(bounds), NSMidY(bounds)) inView:view];
    }
    if (knobMask & MiddleRightKnobMask) {
        [self drawHandleAtPoint:NSMakePoint(NSMaxX(bounds), NSMidY(bounds)) inView:view];
    }
	
    if (knobMask & LowerLeftKnobMask) {
        [self drawHandleAtPoint:NSMakePoint(NSMinX(bounds), NSMaxY(bounds)) inView:view];
    }
    if (knobMask & LowerMiddleKnobMask) {
        [self drawHandleAtPoint:NSMakePoint(NSMidX(bounds), NSMaxY(bounds)) inView:view];
    }
    if (knobMask & LowerRightKnobMask) {
        [self drawHandleAtPoint:NSMakePoint(NSMaxX(bounds), NSMaxY(bounds)) inView:view];
    }
}
@end
