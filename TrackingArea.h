//
//  TrackingArea.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/12/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface TrackingArea : CAShapeLayer {

	@public
	NSPoint startPoint;
	NSPoint endPoint;
}

@property (assign) NSPoint startPoint;
@property (assign) NSPoint endPoint;


@end
