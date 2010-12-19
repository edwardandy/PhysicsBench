//
//  BaseGridView.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 8/29/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "Physics.h"

@class TrackingArea, Document;

@interface BaseGridView : NSView {

	@public
		CALayer				*drawingLayer;
		TrackingArea		*trackingLayer;

	
	@private
 
		struct _TrackingRegion {
			NSPoint startPoint;
			NSPoint endPoint;
		} trackingRegion;
        NSArray	*   _contents;
}


@property (nonatomic, retain) NSArray   *_contents;
@property (nonatomic, retain) CALayer *drawingLayer;

@end

@interface BaseGridView (Tracking)
- (void)graphicsIntersectingRect:(NSRect)rect;
- (void)resetSelectedObjects;
@end