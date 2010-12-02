//
//  PhysicsObject.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/1/10.
//  Copyright 2010 Personal. All rights reserved.
//


#import "Physics.h"

@class PhysicsGrid, Document;

enum {
    NoKnob = 0,
    UpperLeftKnob,
    UpperMiddleKnob,
    UpperRightKnob,
    MiddleLeftKnob,
    MiddleRightKnob,
    LowerLeftKnob,
    LowerMiddleKnob,
    LowerRightKnob,
};

enum {
    NoKnobsMask = 0,
    UpperLeftKnobMask = 1 << UpperLeftKnob,
    UpperMiddleKnobMask = 1 << UpperMiddleKnob,
    UpperRightKnobMask = 1 << UpperRightKnob,
    MiddleLeftKnobMask = 1 << MiddleLeftKnob,
    MiddleRightKnobMask = 1 << MiddleRightKnob,
    LowerLeftKnobMask = 1 << LowerLeftKnob,
    LowerMiddleKnobMask = 1 << LowerMiddleKnob,
    LowerRightKnobMask = 1 << LowerRightKnob,
    AllKnobsMask = 0xffffffff,
};


/*
* Primary class definition for PhysicsObjects
* provides generic definition of the class. PhysicsObjects
* serves as the base class for all objects on screen.
*/
@interface PhysicsObject : NSObject <PhysicsRenderable, Physics2dObject> {
	@public 
		
		// At minimum these fields are defined since 
		// they are an artifact of working within the editor
		NSPoint			position;
		NSSize			size;
		
		BOOL			isVisible;
		BOOL			isSelected; 
		BOOL			isEditing;
		NSArray*		properties;		
	@private	

		NSRect			_bounds;
		Document*		_document;
		struct __gFlags {
			unsigned int drawsFill:1;
			unsigned int drawsStroke:1;
			unsigned int manipulatingBounds:1;
			unsigned int _pad:29;
		} _gFlags;
		
}


// ************************* Properties ******************************
@property (assign) BOOL isVisible;
@property (assign) NSArray*	properties;	

// ************************* Methods ******************************

- (void)didChange;
// This sends the did change notification.  All change primitives should call it.

- (void)setBounds:(NSRect)bounds;
- (NSRect)bounds;
- (NSUndoManager *)undoManager;

// Convenience auto-release creation
+(PhysicsObject*) node;

// Editing
- (void)startEditingWithEvent:(NSEvent *)event inView:(PhysicsGrid *)view;
- (void)endEditingInView:(PhysicsGrid *)view;
- (NSRect)drawingBounds;

// Drawing 
- (void)drawInView:(PhysicsGrid *)view isSelected:(BOOL)flag;
- (void)drawHandleAtPoint:(NSPoint)point inView:(PhysicsGrid *)view;
- (void)drawHandlesInView:(PhysicsGrid *)view;

@end





// ****************************************
// ****************************************

/*
 * Extended class definition to handle on screen event handling. Events are
 * passed from Physics View
 */
@interface PhysicsObject (PhysicsObjectEventHandling)

- (BOOL)isEditable;
- (BOOL)hitTest:(NSPoint)point isSelected:(BOOL)isSelected;

@end





// ****************************************
// ****************************************

/*
 * Extended class definition to handle on screen event handling. Events are
 * passed from Physics View
 */
@interface PhysicsObject (PhysicsDrawing)
- (unsigned)knobMask;
- (int)knobUnderPoint:(NSPoint)point;

@end


