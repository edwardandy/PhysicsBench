//
//  PhysicsObject.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 8/26/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "Workbench.h"

@class PhysicsObject, FrameworkDefinition;



@protocol PhysicsRenderable <RenderLayer>

@required
	- (void) simulateRenderObject;
	- (void) glRenderObject;
@end



@protocol Physics2dFramework

@required
	// Methods for our Physics2d framework
	- (NSArray *)	fetchStringsOfShapesTypes; 
	- (PhysicsObject *) initObjectWithKey:(NSString*)key;
@end



@protocol Physics2dObject

@required
    - (NSArray*) doesConformToFrameworkClasses;	
@end