//
//  PhysicsGrid.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/1/10.
//  Copyright 2010 Personal. All rights reserved.
//


#import "PhysicsGrid.h"
#import "PhysicsGroup.h"
#import "PhysicsObject.h"
#import "Document.h"
#import "GraphicsCocos2dAppDelegate.h"
#import "SKTFoundationExtras.h"

NSString *PhysicsGridViewSelectionDidChangeNotification = @"SKTGraphicViewSelectionDidChange";

@implementation PhysicsGrid

static float SKTDefaultPasteCascadeDelta = 10.0;

@synthesize group, drawDocument;


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		
		
		//self.drawingLayer.delegate = self;	
		[self setWantsLayer:NO];
		
		_selectedGraphics  = [[NSMutableArray allocWithZone:[self zone]] init];
		_pasteCascadeDelta = NSMakePoint(SKTDefaultPasteCascadeDelta, SKTDefaultPasteCascadeDelta);
		_selectedGraphics = [[NSMutableArray allocWithZone:[self zone]] init];
        _creatingGraphic = nil;
        _rubberbandRect = NSZeroRect;
        _rubberbandGraphics = nil;
        _gvFlags.rubberbandIsDeselecting = NO;
        _gvFlags.initedRulers = NO;
        _editingGraphic = nil;
        _pasteCascadeDelta = NSMakePoint(SKTDefaultPasteCascadeDelta, SKTDefaultPasteCascadeDelta);
        _gvFlags.snapsToGrid = NO;
        _gvFlags.showsGrid = NO;
        _gvFlags.knobsHidden = NO;
        _gridSpacing = 8.0;
		

		GraphicsCocos2dAppDelegate *appDelegate = (GraphicsCocos2dAppDelegate*) [[NSApplication sharedApplication] delegate];
		drawDocument = appDelegate.document;
	
    }
    return self;
}



//****************************************************************
// Graphics Drawing
#pragma mark -
#pragma mark Graphics Drawing


- (NSArray *)graphics {
    return [group physicsObjects];
}


- (void)drawRect:(NSRect)rect {
    NSArray *graphics;
    unsigned i;
//	PhysicsGroup *group;
    PhysicsObject *curGraphic;
    BOOL isSelected;
    NSRect drawingBounds;
    NSGraphicsContext *currentContext = [NSGraphicsContext currentContext];
	
    [[NSColor whiteColor] set];
    NSRectFill(rect);
	
	graphics = [drawDocument physicsGroups];
//    graphics = [group physicsObjects];
    //i = [graphics count];
	
	for (PhysicsGroup *grp in graphics) {
		for (curGraphic in [grp physicsObjects]) {
//			curGraphic = [graphics objectAtIndex:i];
			drawingBounds = [curGraphic drawingBounds];
			if (NSIntersectsRect(rect, drawingBounds)) {
				if (!_gvFlags.knobsHidden && (curGraphic != _editingGraphic)) {
					// Figure out if we should draw selected.
					isSelected = [self graphicIsSelected:curGraphic];
					// Account for any current rubberband selection state
					if (_rubberbandGraphics && (isSelected == _gvFlags.rubberbandIsDeselecting) && [_rubberbandGraphics containsObject:curGraphic]) {
						isSelected = (isSelected ? NO : YES);
					}
				} else {
					// Do not draw handles on graphics that are editing.
					isSelected = NO;
				}
				[currentContext saveGraphicsState];
				[NSBezierPath clipRect:drawingBounds];
				[curGraphic drawInView:self isSelected:isSelected];
				[currentContext restoreGraphicsState];
			}
		}
	}
	
    if (_creatingGraphic) {
        drawingBounds = [_creatingGraphic drawingBounds];
        if (NSIntersectsRect(rect, drawingBounds)) {
            [currentContext saveGraphicsState];
            [NSBezierPath clipRect:drawingBounds];
            [_creatingGraphic drawInView:self isSelected:NO];
            [currentContext restoreGraphicsState];
        }
    }
    if (!NSEqualRects(_rubberbandRect, NSZeroRect)) {
        [[NSColor knobColor] set];
        NSFrameRect(_rubberbandRect);
    }
}


// -------------------------------------------------------------------------------
//	drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
//
// This method is being invoked as part of the view API if it is available. It will 
// support drawing the grid and ruler layers until we move them in CALayers
// -------------------------------------------------------------------------------
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO]];
	
	// We need to move everything to a CALayer
	// so we can take advantage of video memory caching
	NSLog(@"TASK 1.1 - VERIFY VIDEO MEMORY IMPROVEMENTS");
		
	// We need to make a call out to all of the objects in the physics group 
	// at this point to wakeup and render themselves
	PhysicsObject *obj;
	for (obj in group.physicsObjects ) {
		if (obj.isVisible && [obj conformsToProtocol:@protocol(PhysicsRenderable) ]) {
			// We want to avoid compiler warnings, we are informing
			// the compiler we know this object has a PhysicsRenderable protocol
			[(id<PhysicsRenderable>)obj simulateRenderObject];
		}
	}
	
	[NSGraphicsContext restoreGraphicsState];
}


// -------------------------------------------------------------------------------
//	renderGroupToScreen:(PhysicsGroup*)newGroup
//
// This method is being invoked as part of the view API if it is available. It will 
// support drawing the grid and ruler layers until we move them in CALayers
// -------------------------------------------------------------------------------
- (void) renderGroupToScreen:(PhysicsGroup*)newGroup; {
	self.group = newGroup;
	
	// Layer managed needs to update layer, otherwise update view
	if ( [self wantsLayer] ) {
		[drawingLayer setNeedsDisplay];
	} else {
		[self setNeedsDisplay:YES];
	}
	
	
}

//****************************************************************
// Event Handling
#pragma mark -
#pragma mark Event Handling

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
	return YES;
}

- (void)mouseDown:(NSEvent *)theEvent {
	// For now we don't have any shared tools, just ignore straight to select
	Class theClass = nil;
	
	
	// If we click more than once we are going to 
	// turn on editing mode for the graphic
	if ([theEvent clickCount] > 1) {
        NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        PhysicsObject *graphic = [self graphicUnderPoint:curPoint];
        if (graphic && [graphic isEditable]) {
            [self startEditingGraphic:graphic withEvent:theEvent];
            return;
        }
    }
	
	// If we have a shared tool that we are using to create a shape manually
	// then respond 
	if (theClass) {
        //[self clearSelection];
        //[self createGraphicOfClass:theClass withEvent:theEvent];
    } else {
        [self selectAndTrackMouseWithEvent:theEvent];
    }
	
	
}

- (void)selectAndTrackMouseWithEvent:(NSEvent *)theEvent {
    NSPoint curPoint;
    PhysicsObject *graphic = nil;
    BOOL isSelected;
    BOOL extending = (([theEvent modifierFlags] & NSShiftKeyMask) ? YES : NO);
	
    curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    graphic = [self graphicUnderPoint:curPoint];
    isSelected = (graphic ? [self graphicIsSelected:graphic] : NO);
	
    if (!extending && !isSelected) {
        [self clearSelection];
    }
	
    if (graphic) {
        // Add or remove this graphic from selection.
        if (extending) {
            if (isSelected) {
                [self deselectGraphic:graphic];
                isSelected = NO;
            } else {
                [self selectGraphic:graphic];
                isSelected = YES;
            }
        } else {
            if (isSelected) {
                int knobHit = [graphic knobUnderPoint:curPoint];
                if (knobHit != NoKnob) {
                    [self trackKnob:knobHit ofGraphic:graphic withEvent:theEvent];
                    return;
                }
            }
            [self selectGraphic:graphic];
            isSelected = YES;
        }
    } else {
        [self rubberbandSelectWithEvent:theEvent];
        return;
    }
	
    if (isSelected) {
        [self moveSelectedGraphicsWithEvent:theEvent];
        return;
    }
	
    // If we got here then there must be nothing else to do.  Just track until mouseUp:.
    while (1) {
        theEvent = [[self window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
        if ([theEvent type] == NSLeftMouseUp) {
            break;
        }
    }
}

- (void)trackKnob:(int)knob ofGraphic:(PhysicsObject *)graphic withEvent:(NSEvent *)theEvent {
    NSPoint point;
    BOOL snapsToGrid = [self snapsToGrid];
    float spacing = _gridSpacing;
    BOOL echoToRulers = [[self enclosingScrollView] rulersVisible];
	
    [graphic startBoundsManipulation];
    if (echoToRulers) {
        [self beginEchoingMoveToRulers:[graphic bounds]];
    }
    while (1) {
        theEvent = [[self window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
        point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        [self invalidateGraphic:graphic];
        if (snapsToGrid) {
            point.x = floor((point.x / spacing) + 0.5) * spacing;
            point.y = floor((point.y / spacing) + 0.5) * spacing;
        }
        knob = [graphic resizeByMovingKnob:knob toPoint:point];
        [self invalidateGraphic:graphic];
        if (echoToRulers) {
            [self continueEchoingMoveToRulers:[graphic bounds]];
        }
        if ([theEvent type] == NSLeftMouseUp) {
            break;
        }
    }
    if (echoToRulers) {
        [self stopEchoingMoveToRulers];
    }
	
    [graphic stopBoundsManipulation];
	
    [[[self drawDocument] undoManager] setActionName:NSLocalizedStringFromTable(@"Resize", @"UndoStrings", @"Action name for resizes.")];
}



//****************************************************************
// Edit Graphics
#pragma mark -
#pragma mark Graphics Editing 
- (void)startEditingGraphic:(PhysicsObject *)graphic withEvent:(NSEvent *)event {
    [graphic startEditingWithEvent:event inView:self];
}




//****************************************************************
// Graphics Selection
#pragma mark -
#pragma mark Graphic Selection 


- (void)clearSelection {
    int i, c = [_selectedGraphics count];
    id curGraphic;
    
    if (c > 0) {
        for (i=0; i<c; i++) {
            curGraphic = [_selectedGraphics objectAtIndex:i];
            [[[self undoManager] prepareWithInvocationTarget:self] selectGraphic:curGraphic];
            [self invalidateGraphic:curGraphic];
        }
        [[[self drawDocument] undoManager] setActionName:NSLocalizedStringFromTable(@"Selection Change", @"UndoStrings", @"Action name for selection changes.")];
        [_selectedGraphics removeAllObjects];
        _pasteCascadeDelta = NSMakePoint(SKTDefaultPasteCascadeDelta, SKTDefaultPasteCascadeDelta);
        [[NSNotificationCenter defaultCenter] postNotificationName:PhysicsGridViewSelectionDidChangeNotification object:self];
        //[self updateRulers];
    }
}

// Geometry calculations
- (PhysicsObject *)graphicUnderPoint:(NSPoint)point {
    NSArray *graphics = group.physicsObjects;
    unsigned i, c = [graphics count];
    PhysicsObject *curGraphic = nil;
	
    for (i=0; i<c; i++) {
        curGraphic = [graphics objectAtIndex:i];
        if ([self mouse:point inRect:[curGraphic drawingBounds]] && [curGraphic hitTest:point isSelected:[self graphicIsSelected:curGraphic]]) {
            break;
        }
    }
    if (i < c) {
        return curGraphic;
    } else {
        return nil;
    }
}

- (BOOL)graphicIsSelected:(PhysicsObject *)graphic {
    return (([_selectedGraphics indexOfObjectIdenticalTo:graphic] == NSNotFound) ? NO : YES);
}

- (void)selectGraphic:(PhysicsObject *)graphic {
    unsigned curIndex = [_selectedGraphics indexOfObjectIdenticalTo:graphic];
    if (curIndex == NSNotFound) {
        [[[self undoManager] prepareWithInvocationTarget:self] deselectGraphic:graphic];
        [[[self drawDocument] undoManager] setActionName:NSLocalizedStringFromTable(@"Selection Change", @"UndoStrings", @"Action name for selection changes.")];
        [_selectedGraphics addObject:graphic];
        [self invalidateGraphic:graphic];
        _pasteCascadeDelta = NSMakePoint(SKTDefaultPasteCascadeDelta, SKTDefaultPasteCascadeDelta);
        [[NSNotificationCenter defaultCenter] postNotificationName:PhysicsGridViewSelectionDidChangeNotification object:self];
        //[self updateRulers];
    }
}

- (void)deselectGraphic:(PhysicsObject *)graphic {
    unsigned curIndex = [_selectedGraphics indexOfObjectIdenticalTo:graphic];
    if (curIndex != NSNotFound) {
        [[[self undoManager] prepareWithInvocationTarget:self] selectGraphic:graphic];
        [[[self drawDocument] undoManager] setActionName:NSLocalizedStringFromTable(@"Selection Change", @"UndoStrings", @"Action name for selection changes.")];
        [_selectedGraphics removeObjectAtIndex:curIndex];
        [self invalidateGraphic:graphic];
        _pasteCascadeDelta = NSMakePoint(SKTDefaultPasteCascadeDelta, SKTDefaultPasteCascadeDelta);
        [[NSNotificationCenter defaultCenter] postNotificationName:PhysicsGridViewSelectionDidChangeNotification object:self];
        //[self updateRulers];
    }
}

// Display invalidation
- (void)invalidateGraphic:(PhysicsObject *)graphic {
    /*[self setNeedsDisplayInRect:[graphic drawingBounds]];
    if (![[self graphics] containsObject:graphic]) {
        [self deselectGraphic:graphic];  // deselectGraphic will call invalidateGraphic, too, but only if the graphic is in the selection and since the graphic is removed from the selection before this method is called again the potential infinite loop should not happen.
    }
	 */
}


- (void)rubberbandSelectWithEvent:(NSEvent *)theEvent {
    NSPoint origPoint, curPoint;
    NSEnumerator *objEnum;
    PhysicsObject *curGraphic;
	
    _gvFlags.rubberbandIsDeselecting = (([theEvent modifierFlags] & NSAlternateKeyMask) ? YES : NO);
    origPoint = curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	
    while (1) {
        theEvent = [[self window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
        curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        if (NSEqualPoints(origPoint, curPoint)) {
            if (!NSEqualRects(_rubberbandRect, NSZeroRect)) {
                [self setNeedsDisplayInRect:_rubberbandRect];
                [self performSelector:@selector(invalidateGraphic:) withEachObjectInSet:_rubberbandGraphics];
            }
            _rubberbandRect = NSZeroRect;
            [_rubberbandGraphics release];
            _rubberbandGraphics = nil;
        } else {
            NSRect newRubberbandRect = SKTRectFromPoints(origPoint, curPoint);
            if (!NSEqualRects(_rubberbandRect, newRubberbandRect)) {
                [self setNeedsDisplayInRect:_rubberbandRect];
                [self performSelector:@selector(invalidateGraphic:) withEachObjectInSet:_rubberbandGraphics];
                _rubberbandRect = newRubberbandRect;
                [_rubberbandGraphics release];
                _rubberbandGraphics = [[self graphicsIntersectingRect:_rubberbandRect] retain];
                [self setNeedsDisplayInRect:_rubberbandRect];
                [self performSelector:@selector(invalidateGraphic:) withEachObjectInSet:_rubberbandGraphics];
            }
        }
        if ([theEvent type] == NSLeftMouseUp) {
            break;
        }
    }
	
    // Now select or deselect the rubberbanded graphics.
    objEnum = [_rubberbandGraphics objectEnumerator];
    while ((curGraphic = [objEnum nextObject]) != nil) {
        if (_gvFlags.rubberbandIsDeselecting) {
            [self deselectGraphic:curGraphic];
        } else {
            [self selectGraphic:curGraphic];
        }
    }
    if (!NSEqualRects(_rubberbandRect, NSZeroRect)) {
        [self setNeedsDisplayInRect:_rubberbandRect];
    }
	
    _rubberbandRect = NSZeroRect;
    [_rubberbandGraphics release];
    _rubberbandGraphics = nil;
}

- (NSSet *)graphicsIntersectingRect:(NSRect)rect {
    NSArray *graphics = [self graphics];
    unsigned i, c = [graphics count];
    NSMutableSet *result = [NSMutableSet set];
    PhysicsObject *curGraphic;
	
    for (i=0; i<c; i++) {
        curGraphic = [graphics objectAtIndex:i];
        if (NSIntersectsRect(rect, [curGraphic drawingBounds])) {
            [result addObject:curGraphic];
        }
    }
    return result;
}

@end
