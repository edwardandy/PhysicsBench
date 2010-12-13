//
//  FrameworkManager.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/2/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Physics.h"

#define CLASS_DEF_ROOT @"ClassDef"

@class FrameworkDefinition, PhysicsObject, FrameworkClass;

@interface FrameworkManager : NSObject <Physics2dFramework>{
	id<Physics2dFramework>	framework;
    // Force our frameworks to initialize a defintion
	FrameworkDefinition *definition;

}

// Properties
@property (readonly) FrameworkDefinition *definition;
@property(assign) 	id<Physics2dFramework>	framework;

// Static Methods
+ (id)  sharedFrameworkManager;
+ (FrameworkDefinition*) loadFrameworkFromFile:(NSString*)file;

// Methods
- (NSArray*) bindFrameworkToClass:(PhysicsObject*)obj;
- (NSArray*) queryFrameworkClassForProperties:(FrameworkClass*) fClass; 

@end


