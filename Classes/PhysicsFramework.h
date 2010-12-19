//
//  PhysicsFramework.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/19/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "Physics.h"

#define CLASS_DEF_ROOT @"ClassDef"

@interface PhysicsFramework : NSObject <Physics2dFramework> {

    @public
        FrameworkDefinition *definition;

    @private
    
}

@property (nonatomic, retain) FrameworkDefinition *definition;

- (FrameworkDefinition*) loadFrameworkFromFile:(NSString*)file;
- (void) bindFrameworkToClass:(PhysicsObject*)obj;

@end
