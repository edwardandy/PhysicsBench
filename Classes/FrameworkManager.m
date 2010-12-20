//
//  FrameworkManager.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/2/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "FrameworkManager.h"
#import "PhysicsObject.h"
#import "PropertyView.h"

/**
 * <p>
 * Framework manager is responsible for obscuring the implementation 
 * of the actual framework that is in place during run-time. This allows us
 * to assume a general set of operations are available within the framework
 * and perform them at any time. This provides the forward contract of how
 * to work with a frameowrk. 
 * </p>
 */
@implementation FrameworkManager

@synthesize framework, _pView;

/**
 * Provides a shared instance of the framework manager. Allows for all classes
 * interested to work on a synchronized instance. 
 */
+ (id) sharedFrameworkManager
{
    static FrameworkManager * shared = nil;
	
    if ( !shared )
        shared = [[self alloc] init];
	
    return shared;
}

/** 
 * Standard init method
 */
- (id) init
{
	self = [super init];
	if (self != nil) {
		if ( framework == nil ) {
			NSLog(@"No framework specified...defaulting to Box2d");
			framework = [[NSClassFromString(DEFAULT_FRAMEWORK_CLASS) alloc] init];	
		}
	}
	return self;
}

/**
 * Standard memory-management dealloc
 */
- (void)dealloc {
    [_pView release];
    [framework release];
    [super dealloc];
}


#pragma mark - 
#pragma mark Delegate Routines

/**
 * @Abstract Method
 *
 * Responsible for calling subroutine within initialized framework
 */
- (PhysicsObject *) initObjectWithKey:(NSString*)key {
	if ( framework != nil ) {
		[framework initObjectWithKey:key];	
	}
    return nil;
}


/**
 * @Abstract Method
 *	fetchStringsOfShapesTypes
 *
 * Responsible for calling subroutine within initialized framework
 */
- (NSArray *) fetchStringsOfShapesTypes {
	if ( framework != nil ) {
		return [framework fetchStringsOfShapesTypes];	
	}
	return nil;
}

/**
 * Property manager for displaying 
 */
- (void)setPropertyManager:(PropertyView*)pView {
    _pView = pView;            
}

/**
 * Display framework properties
 */
- (void)displayFrameworkProperties:(NSArray*)properties {
    [_pView displayAllProperties:properties];
}

@end
