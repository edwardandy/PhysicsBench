//
//  Box2dFramework.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/2/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "Box2dFramework.h"

#import "Document.h"
#import "GraphicsCocos2dAppDelegate.h"

#import "GCb2Circle.h"
#import "GCb2Rect.h"
#import "FrameworkManager.h"


@interface Box2dFramework (Private)
- (void) createObjectInCurDoc:(id)object;

@end



@implementation Box2dFramework

@synthesize definition;

- (id) init
{
	self = [super init];
	if (self != nil) {
		//
		definition = [FrameworkManager loadFrameworkFromFile:[[NSBundle mainBundle] pathForResource:@"GCb2Types" ofType:@"plist"]]; 
	}
	return self;
}


#pragma mark Physics2dFramework Delegate

// -------------------------------------------------------------------------------
// fetchStringsOfShapesTypes
//
// Fetch the available string shape types, we will hold on to this
// internally to build out our object types
// -------------------------------------------------------------------------------

- (NSArray *) fetchStringsOfShapesTypes {
	// This isn't going to change during run-time
	NSArray *objectTypes = [[NSArray arrayWithObjects:@"Circle", @"Rectangle", nil] retain];
	return objectTypes;
}

// -------------------------------------------------------------------------------
// @Abstract Method
//	initObjectWithKey:(NSString*)key
//
// Responsible for calling subroutine within initialized framework
// -------------------------------------------------------------------------------
- (PhysicsObject *) initObjectWithKey:(NSString*)key {
	if ( [key compare:@"Circle"] == NSOrderedSame ) {
		NSLog(@"Creating a new circle object");	
		PhysicsObject *circle = [GCb2Circle node];
		return circle;
	}
	
	else if ( [key compare:@"Rectangle"] == NSOrderedSame ) {
		NSLog(@"Creating a new circle object");	
		PhysicsObject *rectangle = [GCb2Rect node];
		return rectangle;
	}
	return nil;
}


// -------------------------------------------------------------------------------
// @Abstract Method
// createObjectWithKey:(NSString*)key
//
// Responsible for calling defined frameworks method
// -------------------------------------------------------------------------------
- (void) createObjectWithKey:(NSString*)key {
	if ( [key compare:@"Circle"] == NSOrderedSame ) {
		NSLog(@"Creating a new circle object");	
		PhysicsObject *circle = [GCb2Circle node];
		[self createObjectInCurDoc:circle];
	}
	
	else if ( [key compare:@"Rectangle"] == NSOrderedSame ) {
		NSLog(@"Creating a new circle object");	
		PhysicsObject *rectangle = [GCb2Rect node];
		[self createObjectInCurDoc:rectangle];
	}
}

// -------------------------------------------------------------------------------
//	createObjectWithKey:(NSString*)key inGroup:(id)group
//
//	Create new object within specified group
// -------------------------------------------------------------------------------
- (void) createObjectWithKey:(NSString*)key inGroup:(id)group {
	NSException* myException = [NSException
								exceptionWithName:@"MethodIncomplete"
								reason:@"Framework could not provide complete implementation yet"
								userInfo:nil];
	@throw myException;

}

#pragma mark Box2dFramework Delegate

- (void) createObjectInCurDoc:(id)object {
	GraphicsCocos2dAppDelegate *delegate = [[NSApplication sharedApplication] delegate];
	
	// This needs to change this isn't safe, document should dictate this
	
	
	
}

@end
