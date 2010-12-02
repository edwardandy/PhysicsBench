//
//  FrameworkManager.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/2/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "FrameworkManager.h"
// This is our default physics framework 
// provider
#import "FrameworkDefinition.h"
#import "FrameworkClass.h"


#define DEFAULT_FRAMEWORK_CLASS @"Box2dFramework"



@implementation FrameworkManager

@synthesize framework;

+ (id) sharedFrameworkManager
{
    static FrameworkManager * shared = nil;
	
    if ( !shared )
        shared = [[self alloc] init];
	
    return shared;
}

// -------------------------------------------------------------------------------
//	init
//
//	Provide framework management, default 
// -------------------------------------------------------------------------------
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

#pragma mark - 
#pragma mark Delegate Routines

// -------------------------------------------------------------------------------
// @Abstract Method
//	initObjectWithKey:(NSString*)key
//
// Responsible for calling subroutine within initialized framework
// -------------------------------------------------------------------------------
- (PhysicsObject *) initObjectWithKey:(NSString*)key {
	if ( framework != nil ) {
		[framework initObjectWithKey:key];	
	}
}


// -------------------------------------------------------------------------------
// @Abstract Method
//	fetchStringsOfShapesTypes
//
// Responsible for calling subroutine within initialized framework
// -------------------------------------------------------------------------------
- (NSArray *) fetchStringsOfShapesTypes {
	if ( framework != nil ) {
		return [framework fetchStringsOfShapesTypes];	
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
	if ( framework != nil ) {
		[framework createObjectWithKey:key];	
	}
	return ;
}

// -------------------------------------------------------------------------------
// @Abstract Method
//	createObjectWithKey:(NSString*)key inGroup:(id)group
//
//	Create new object within specified group
// -------------------------------------------------------------------------------
- (void) createObjectWithKey:(NSString*)key inGroup:(id)group {
	if ( framework != nil ) {
		[framework createObjectWithKey:key inGroup:group];
	}
	return ;		
}


// -------------------------------------------------------------------------------
// loadFrameworkFromFile:(NSString*)file
//
// Utility method that creates a 
// -------------------------------------------------------------------------------
+ (FrameworkDefinition*) loadFrameworkFromFile:(NSString*)file {
	// Load file Data
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:file];
	NSArray *classes = [dict objectForKey:CLASS_DEF_ROOT];
	
	// Retrieve file data and store in new array
	NSDictionary   *classDef = nil;
	NSMutableSet   *classSet = [[NSMutableSet alloc] init];
	
	for (classDef in classes) {
		// Prepare class
		FrameworkClass *newClass = [[FrameworkClass alloc] init];
		
		
		// Create class
		newClass.className	= [classDef objectForKey:@"classname"];
		newClass.type		= [classDef objectForKey:@"type"];
		
		// Define class fields
		
		for (NSDictionary *dict in (NSArray*)[classDef objectForKey:@"fields"]) {
			FrameworkField *field = [[FrameworkField alloc] init];
			
			// Define field
			NSString *tClass = [dict objectForKey:@"class"];
			NSString *tKey = [dict objectForKey:@"key"];
			
			if ( nil != tClass ) {
				field.type = tClass;	
			}
			if ( nil != tKey ) {
				field.key = tKey;	
			}
			
			[newClass.fields addObject:field];
		}
		
		// Add class
		[classSet addObject:newClass];
	}
	
	[classDef release];
	
	
	// Create our framework defintion
	FrameworkDefinition *def = [[FrameworkDefinition alloc] initWithSet:classSet];
	return def;
}

// -------------------------------------------------------------------------------
// bindFrameworkToClass:(PhysicsObject *)obj
//
// Bind framework 
// -------------------------------------------------------------------------------
- (NSArray *) bindFrameworkToClass:(PhysicsObject *)obj {
    // We've found our binding classes
	NSArray *bindings = [obj doesConformToFrameworkClasses];
	NSArray *temp = nil;
	
	// Lets build our predicate statement
	if ( [bindings count] > 0 ) {
		NSSet *classes = [framework.definition classDefs];
		for (FrameworkClass*clazz in classes) {
			NSLog(@"%@", clazz.className);
		}
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat: @"className IN %@" , bindings];
		NSSet *results = [classes filteredSetUsingPredicate:predicate];
		temp = [results allObjects];
	}
	
	return temp;
}


- (NSArray*) queryFrameworkClassForProperties:(FrameworkClass*) fClass {
	
}
@end
