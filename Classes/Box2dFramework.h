//
//  Box2dFramework.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/2/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "Physics.h"

@interface Box2dFramework : NSObject <Physics2dFramework> {
    	FrameworkDefinition *definition;
}
	@property (readonly) FrameworkDefinition *definition;

@end
