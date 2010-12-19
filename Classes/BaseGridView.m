//
//  BaseGridView.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 8/29/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "BaseGridView.h"
#import "GridLayer.h"
#import "RulerLayer.h"
#import "TrackingArea.h"
#import "GCTabController.h"

#import "GraphicsCocos2dAppDelegate.h"
#import "MyWindowController.h"

@interface BaseGridView (Private)
//- (void) drawGridLayer;
- (void) drawRulerLayer;
- (void) trackMouseWithEvent:(NSEvent*)theEvent;
@end



@implementation BaseGridView

@synthesize drawingLayer, _contents;

// -------------------------------------------------------------------------------
// Initialization
// -------------------------------------------------------------------------------
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

		[self setWantsLayer:YES];
		self.layer.frame = NSRectToCGRect(frame); 
		// Initialization code here.
		
		// Video-memory backed layers
		// Draw our grid
		CALayer *gridLayer = [GridLayer layer];
		gridLayer.frame = NSRectToCGRect(frame);
		[self.layer addSublayer:gridLayer];
		[gridLayer display];
		
		// Draw our ruler
		/*CALayer *rulerLayer = [RulerLayer layer];
		rulerLayer.frame = self.frame;
		[self.layer addSublayer:rulerLayer];
		[rulerLayer display];*/
		
		// IDE layers are responsible for 
		// the drawing layer
		drawingLayer = [CALayer layer];
		drawingLayer.frame =  NSRectToCGRect(frame);
		[self.layer addSublayer:drawingLayer];
		
		trackingLayer = [TrackingArea layer];
		[self.layer addSublayer:trackingLayer];
		
        
    }
    return self;
}

- (void) dealloc
{
	[drawingLayer release];
	[trackingLayer release];
	[super dealloc];
}


#pragma mark -
#pragma mark MouseEventHandling

// -------------------------------------------------------------------------------
//	acceptsFirstMouse:(NSEvent *)theEvent
// -------------------------------------------------------------------------------
- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
	return YES;
}

// -------------------------------------------------------------------------------
//	mouseDown:(NSEvent *)theEvent
// -------------------------------------------------------------------------------
- (void)mouseDown:(NSEvent *)theEvent {
	// State 1 
	// Selecting a graphic
	
	// State 2
	// Tracking Event
	[self trackMouseWithEvent:theEvent];
}

// -------------------------------------------------------------------------------
//	trackMouseWithEvent:(NSEvent*)theEvent
// -------------------------------------------------------------------------------
- (void) trackMouseWithEvent:(NSEvent*)theEvent {
	BOOL rubberband = YES;
	
	if ( rubberband ) {
		BOOL keepOn = YES; 
		BOOL isInside = YES;
		NSPoint mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];

		// Reset tracking area
		trackingRegion.startPoint = NSZeroPoint;
		trackingRegion.endPoint = NSZeroPoint;
        [self resetSelectedObjects];
		CGMutablePathRef mutablePath = CGPathCreateMutable();
		CGPathAddRect(mutablePath, NULL, CGRectMake(trackingRegion.startPoint.x, trackingRegion.startPoint.y, trackingRegion.endPoint.x - trackingRegion.startPoint.x, trackingRegion.endPoint.y - trackingRegion.startPoint.y));
		[trackingLayer setPath:mutablePath];
		[trackingLayer display];
		[trackingLayer setHidden:NO];
		
		
		trackingRegion.startPoint = mouseLoc;
		// Enter our tight-loop, rather than trying to take a multiresponder approach apple
		// suggests just tracking the event until we are done processing. This puts us
		// in a constant state until we are done
		while ( keepOn ) {
			theEvent = [[self window] nextEventMatchingMask: NSLeftMouseUpMask |
						NSLeftMouseDraggedMask]; 
			mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
			isInside = [self mouse:mouseLoc inRect:[self bounds]];

			switch ([theEvent type]) {
				case NSLeftMouseDragged:

					trackingRegion.endPoint = mouseLoc;
					
					NSRect rect = NSMakeRect(trackingRegion.startPoint.x, trackingRegion.startPoint.y, trackingRegion.endPoint.x - trackingRegion.startPoint.x, trackingRegion.endPoint.y - trackingRegion.startPoint.y);
					
					CGMutablePathRef mutablePath = CGPathCreateMutable();
					CGPathAddRect(mutablePath, NULL, NSRectToCGRect(rect));
					
					// Update tracking marquee
					[trackingLayer setPath:mutablePath];
					[trackingLayer setLineWidth:1.0f];
					[trackingLayer setStrokeColor:CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1.0)];
					[trackingLayer setFillColor:CGColorCreateGenericRGB(0.5, 0.7, 0.7, 0.2)];					
					[trackingLayer display];
				
					[self graphicsIntersectingRect:rect];
					break;
				case NSLeftMouseUp:
					// Break out of tight-loop
					keepOn = NO;
					[trackingLayer setHidden:YES];
					break;
				default:
					// Ignore all other events
					break;
			
			}			
		}
		
	}
}


/**
 * Graphics intersecting should be implemented by subclass
 */
- (void)graphicsIntersectingRect:(NSRect)rect {
    [NSException raise:NSInternalInconsistencyException 
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

/**
 * 
 */
- (void)resetSelectedObjects {
    [NSException raise:NSInternalInconsistencyException 
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
