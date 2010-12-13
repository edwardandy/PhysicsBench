//
//  GCb2Circle.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/1/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "Physics.h"
#import "PhysicsObject.h"

#define BINDING_SHAPE_CLASS @"b2CircleShape"

@interface GCb2Circle : PhysicsObject <PhysicsRenderable> {
	float	radius;
}

@end
