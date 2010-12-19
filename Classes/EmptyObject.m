//
//  EmptyObject.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/17/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "EmptyObject.h"


@implementation EmptyObject

// -------------------------------------------------------------------------------
//	init
//
//	Provide document standard properties on initialization
// -------------------------------------------------------------------------------
- (id) init
{
	self = [super init];
	if (self != nil) {	
	}
	return self;
}


- (void)dealloc {
    // Clean-up code here.
    [super dealloc];
}

#pragma mark -
#pragma PhysicsRenderable Implementation

// -------------------------------------------------------------------------------
//	simulateRenderObject
//
//	Render a 2d representation of the circle within the workbench
// -------------------------------------------------------------------------------
- (void) simulateRenderObject {
	NSLog(@"Group Object, empty render");
}

- (void) glRenderObject {
	
}

#pragma mark -
#pragma mark Physics2dObject protocol

- (NSArray*) doesConformToFrameworkClasses {
	return 	[NSArray arrayWithObjects: nil ];
}

@end
