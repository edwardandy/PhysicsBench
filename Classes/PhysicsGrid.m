//  PhysicsGrid.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/1/10.
//  Copyright 2010 Personal. All rights reserved.
//


#import "PhysicsGrid.h"
#import "Document.h"
#import "WorkspaceObject.h"


@interface PhysicsGrid (PrivateMethods) 
- (void) render:(id)sender;
- (void) walkLayerTreeRender:(CALayer*)aLayer;
@end


@implementation PhysicsGrid

@synthesize _document, _renderTimer;


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
                [obj setNeedsDisplay];    
            }
        }
    }
}
     
@end
