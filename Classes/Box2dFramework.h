//
//  Box2dFramework.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/2/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "PhysicsFramework.h"

@interface Box2dFramework : PhysicsFramework {

    
    @private
        NSDictionary *frameworkClasses;
}

@property (nonatomic, retain) NSDictionary *frameworkClasses;

@end
