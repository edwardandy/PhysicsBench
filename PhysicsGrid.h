//
//  PhysicsGrid.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/1/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "BaseGridView.h"

#define SKT_HALF_HANDLE_WIDTH 3.0
#define SKT_HANDLE_WIDTH (SKT_HALF_HANDLE_WIDTH * 2.0)


@class PhysicsGroup, PhysicsObject, Document;

@interface PhysicsGrid : BaseGridView {
	
	NSMutableArray		*_selectedGraphics;
	Document			*drawDocument;
	NSPoint				_pasteCascadeDelta;
	
@private 	
	PhysicsGroup*		group;	
	NSRect				_rubberbandRect;
    NSSet *				_rubberbandGraphics;
	float				_gridSpacing;
	PhysicsObject *		_editingGraphic;
	PhysicsObject *		_creatingGraphic;
	struct __gvFlags {
        unsigned int rubberbandIsDeselecting:1;
        unsigned int initedRulers:1;
        unsigned int snapsToGrid:1;
        unsigned int showsGrid:1;
        unsigned int knobsHidden:1;
        unsigned int _pad:27;
    } _gvFlags;
}

// *************************
// Properties 
@property (nonatomic, retain)	Document		*drawDocument;
@property (nonatomic, retain) 	PhysicsGroup	*group;	

// Property Accessors
- (NSArray *)graphics;

// *************************
// Methods

// Event Handling
- (void)selectAndTrackMouseWithEvent:(NSEvent *)theEvent;

// Graphics Rendering
- (void) renderGroupToScreen:(PhysicsGroup*)newGroup;

// Graphics Editing
- (void)startEditingGraphic:(PhysicsObject *)graphic withEvent:(NSEvent *)event;
- (void)trackKnob:(int)knob ofGraphic:(PhysicsObject *)graphic withEvent:(NSEvent *)theEvent;

// Graphic selection
- (PhysicsObject *)graphicUnderPoint:(NSPoint)point;
- (BOOL)graphicIsSelected:(PhysicsObject *)graphic;
- (void)selectGraphic:(PhysicsObject *)graphic;
- (void)deselectGraphic:(PhysicsObject *)graphic;
- (void)invalidateGraphic:(PhysicsObject *)graphic;
- (void)clearSelection;
- (void)rubberbandSelectWithEvent:(NSEvent *)theEvent;
- (NSSet *)graphicsIntersectingRect:(NSRect)rect;


@end

// *************************
// Register Notifications
extern NSString *PhysicsGridViewSelectionDidChangeNotification;