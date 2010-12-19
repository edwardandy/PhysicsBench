//
//  FrameworkManager.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/2/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>


#define DEFAULT_FRAMEWORK_CLASS @"Box2dFramework"

@class PhysicsFramework;

@interface FrameworkManager : NSObject{
	PhysicsFramework	*framework;
}

// Properties
@property(assign) 	PhysicsFramework *framework;

// Static Methods
+ (id)  sharedFrameworkManager;
- (NSArray *) fetchStringsOfShapesTypes;


@end


