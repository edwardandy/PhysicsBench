//
//  FrameworkDefinition.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/4/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FrameworkDefinition : NSObject {
	NSSet *	classDefs;
}

@property  (readonly) NSSet *classDefs;

- (id) initWithSet:(NSSet*)defSet;


@end
