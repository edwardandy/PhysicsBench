//
//  Box2dFramework.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/2/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "Box2dFramework.h"


@implementation Box2dFramework
 
@synthesize frameworkClasses;


/**
 * Standard init
 */
- (id) init
{
	self = [super init];
	if (self != nil) {
		//
		definition = [super loadFrameworkFromFile:[[NSBundle mainBundle] pathForResource:@"GCb2Types" ofType:@"plist"]];
        
        frameworkClasses = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"GCb2Circle", @"Circle",
                            @"GCb2Rect", @"Rectangle",
                            nil];
	}
	return self;
}

/**
 * Standard memory-management dealloc
 */
- (void)dealloc {
    [frameworkClasses release];
    [definition release];
    [super dealloc];
}


#pragma mark 
#pragma mark Physics2dFramework Delegate

/**
 * Fetch the available string shape types, we will hold on to this
 * internally to build out our object types
 */
- (NSArray *) fetchStringsOfShapesTypes {
	// This isn't going to change during run-time
	return [frameworkClasses allKeys];
    
}

/**
 * Creates a class based on the framework type dynamically. These classes
 * are constructed at run-time. If the class does not exist nil is returned.
 */
- (PhysicsObject *) initObjectWithKey:(NSString*)key {
    
    // Attempt to create object
	NSLog(@"Creating a %@", key);
    
    // Class type to create
    Class classRef = NSClassFromString([frameworkClasses objectForKey:key]);
    if ( nil == classRef ) {
        return nil;
    }
    
    // Dynamically create a new object from Class
    PhysicsObject * obj = (PhysicsObject*) [[classRef alloc] init];
    
    // Bind our Object to its framework
    [self bindFrameworkToClass:obj];
    
    return obj;
}


@end
