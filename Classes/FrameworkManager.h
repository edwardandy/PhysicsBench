//
//  FrameworkManager.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/2/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>



#define DEFAULT_FRAMEWORK_CLASS @"Box2dFramework"

@class PhysicsFramework, PropertyView;

@interface FrameworkManager : NSObject{
	PhysicsFramework	*framework;
    
    @private
        PropertyView      *_pView;
}

// Properties
@property(assign) 	PhysicsFramework *framework;
@property(nonatomic, retain) PropertyView      *_pView;

// Static Methods
+ (id)  sharedFrameworkManager;
- (NSArray *) fetchStringsOfShapesTypes;
- (void)setPropertyManager:(PropertyView*)pView;
- (void)displayFrameworkProperties:(NSArray*)properties;


@end


