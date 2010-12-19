//  PhysicsGrid.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/1/10.
//  Copyright 2010 Personal. All rights reserved.
//


#import "PhysicsGrid.h"
#import "Document.h"
#import "WorkspaceObject.h"
#import "EmptyObject.h"


@interface PhysicsGrid (PrivateMethods) 
- (void) render:(id)sender;
- (void) walkLayerTreeRender:(CALayer*)aLayer;
- (void) selectorOnAllSubLayers:(CALayer*)aLayer withSelector:(SEL)callback withTarget:(id)target;
- (void) performGraphicReset:(WorkspaceObject*)workspaceObject;
@end


@implementation PhysicsGrid

@synthesize _renderTimer, _document;


/**
 * Standard view initialization, we should
 * note that the frame is at 1:1 world ratio
 */
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

/**
 * Memory-management deallocation
 */
- (void)dealloc {
    // Memory-management goes here
    [super dealloc];
}

/**
 * Initialize our grid with a document
 */
- (void) gridWithDocument:(Document*) newDocument {
    
    // Grab the document
    _document = newDocument;
    
    // Update the hiearchy to include 
    // the new layers
    [drawingLayer addSublayer:_document.rootLayer];

    // Create a render loop
    NSTimeInterval interval = 1/30;
    _renderTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(render:) userInfo:nil repeats:YES];
    [_renderTimer fire];

}

/**
 * Our render lifecycle which manages updating the screen
 * at 1/30 fps 
 */
- (void) render:(id)sender {

    // We should find out if we are in mid-update
    // and skip till next render cycle
    
    // lock out multiple render request,
    // pseudo synchrnoized since we are not queueing
    static BOOL rendering = false;

    // Quickly short-circuit if we are rendering
    if ( rendering )  {
        return ;
    }
    
    // Lock the render loop
    rendering = true;
    
    // Scroll the sub layers and refresh if needed
    [self walkLayerTreeRender:_document.rootLayer];
    
    rendering = false;
}

/**
 * Tree walker navigates the layers and updates only
 * when a change has occured. Each layer is responsible
 * in issuing an update request. 
 */
- (void) walkLayerTreeRender:(CALayer*)aLayer {
    // Retrieves the current layers
    NSArray *layers = [aLayer sublayers];
    
    CALayer *nLayer;
    for ( nLayer in layers ) {
        // If the layer we are working on has sublayers recursively
        // call first to ensure we move from back to forwards
        NSArray *nSubLayers = [nLayer sublayers];
        if ( nil != nSubLayers ) {
            [self walkLayerTreeRender:nLayer];
        }
        
        // First make sure that we are a workspace object

        if ( [nLayer isKindOfClass:[WorkspaceObject class]]) {
            WorkspaceObject *obj = (WorkspaceObject*)nLayer;
            if ([obj needsRender] ) {
                [obj display];   
                [obj setNeedsLayout];
                [obj setNeedsRender:YES];
                [obj setNeedsDisplay];
            }
        }
    }
}
    
/**
 * <p>
 * Responds with a set of objects within the grid that will respond as selected
 * items based on coordinate space provided within the rect
 * </p>
 *
 * <b>Parameters</p>
 * <i>rect</i>
 *   NSRect that contains the coordinate space for handling intersections
 * 
 * <b>Return Value</b>
 * An NSSet that contains all WorkspaceObjects that intersect to tracking rect
 */
- (void)graphicsIntersectingRect:(NSRect)rect withLayer:(CALayer*)aLayer{

    CGRect cgRect = NSRectToCGRect(rect);
    NSArray *graphics = [aLayer sublayers];
    
    CALayer *nLayer;
    for ( nLayer in graphics ) {
        // If the layer we are working on has sublayers recursively
        // call first to ensure we move from back to forwards
        NSArray *nSubLayers = [nLayer sublayers];
        if ( nil != nSubLayers ) {
            [self graphicsIntersectingRect:rect withLayer:nLayer];
        }
        
        // First make sure that we are a workspace object
        
        if ( [nLayer isKindOfClass:[WorkspaceObject class]] ) {
			CGRect nrect = [self.layer convertRect:cgRect toLayer:nLayer];
            WorkspaceObject *obj = (WorkspaceObject*)nLayer;
			// We want to continually render updates, during these calls we are
            // constantly being asked to update the state, we will flip the flags
            // back and forth.
            if ( NSIntersectsRect(NSRectFromCGRect(nrect), NSRectFromCGRect(obj.bounds)) ) {
				
                // optimize the call
                if ( ![obj isSelected] ) {
                    [obj setIsSelected:YES];
                    [obj setNeedsRender:YES];
                }
			} else {
                
                // optimize the call
                if ( [obj isSelected] ) {
                    [obj setIsSelected:NO];
                    [obj setNeedsRender:YES];
                }
            }
        }
    }
}

/**
 * Wrapper function for abstracted method within parent class. This forces the root
 * layer from our document to respond and check if there are any fields that have been selected. 
 * if so it will take care of selecting and the render loop should catch the changes.
 */
- (void)graphicsIntersectingRect:(NSRect)rect {
    CALayer *rootLayer = _document.rootLayer;
    [self graphicsIntersectingRect:rect withLayer:rootLayer];
}

/**
 * Responds to requests to reset all selections on an object
 */
- (void) resetSelectedObjects {
    [self performSelectorOnAllGraphics:@selector(performGraphicReset:) withTarget:self];
}

/**
 *
 */
- (void) performGraphicReset:(WorkspaceObject*)workspaceObject {
    [workspaceObject setIsSelected:NO];
    [workspaceObject setNeedsRender:YES];
}

- (void) performSelectorOnAllGraphics:(SEL)callback withTarget:(id)target {
    CALayer *rootLayer = _document.rootLayer;
    [self selectorOnAllSubLayers:rootLayer withSelector:callback withTarget:target];
}

- (void) selectorOnAllSubLayers:(CALayer*)aLayer withSelector:(SEL)callback withTarget:(id)target {
    
    CALayer *nLayer;
    NSArray *graphics = [aLayer sublayers];
    
    for ( nLayer in graphics ) {
        // If the layer we are working on has sublayers recursively
        // call first to ensure we move from back to forwards
        NSArray *nSubLayers = [nLayer sublayers];
        if ( nil != nSubLayers ) {
            [self selectorOnAllSubLayers:nLayer withSelector:callback withTarget:target];
        }
        
        // First make sure that we are a workspace object
        
        if ( [nLayer isKindOfClass:[WorkspaceObject class]]) {
			[target performSelector:callback withObject:nLayer];
        }
    }    
}

@end
