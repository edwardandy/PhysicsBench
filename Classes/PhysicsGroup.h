//
//  PhysicsGroup.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/1/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PhysicsObject;

@interface PhysicsGroup : NSObject {
	NSMutableArray			*physicsObjects;
	PhysicsObject			*currentObject;
}

@property (nonatomic, retain) NSMutableArray 	*physicsObjects;
@property (nonatomic, retain) PhysicsObject		*currentObject;

@end
