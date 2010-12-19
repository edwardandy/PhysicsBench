//
//  PhysicsFramework.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/19/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "PhysicsFramework.h"
#import "FrameworkDefinition.h"
#import "PhysicsObject.h"
#import "FrameworkClass.h"


@implementation PhysicsFramework

@synthesize definition;


- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
        definition = nil;
    }
    
    return self;
}

- (void)dealloc {
    // Clean-up code here.
    [definition release];
    [super dealloc];
}

/**
 * Bind framework classes to our physical object. This updates the Physics object
 * properties with the framework classes that the framework supposedly responds to.
 */
- (void) bindFrameworkToClass:(PhysicsObject *)obj {
    // We've found our binding classes
	NSArray *bindings = [obj doesConformToFrameworkClasses];
	NSMutableArray *fwClasses = [[NSMutableArray alloc] init];
    
    for (NSString *clazz in bindings){
        FrameworkClass * clz = [definition classWithName:clazz];
        if ( nil != clz ) {
            [fwClasses addObject:clz];
        }
    }
	
    [obj setProperties:fwClasses];
}

/**
 * Loads a framework definition file that can then 
 */
- (FrameworkDefinition*) loadFrameworkFromFile:(NSString*)file {
	// Load file Data
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:file];
	NSArray *classes = [dict objectForKey:CLASS_DEF_ROOT];
	
	// Retrieve file data and store in new array
	NSDictionary   *classDef = nil;
	NSMutableSet   *classSet = [[NSMutableSet alloc] init];
	NSMutableDictionary *classHash = [[NSMutableDictionary alloc] init];
    
    
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
        [classHash setValue:newClass forKey:newClass.className];
	}
	
	[classDef release];
	
	
	// Create our framework defintion
	FrameworkDefinition *def = [[FrameworkDefinition alloc] initWithSet:classSet];
    def._classDictionary = [[NSDictionary dictionaryWithDictionary:classHash] retain];
	return def;
}

/**
 * @abstract method, subclass must implement
 */
- (NSArray *)	fetchStringsOfShapesTypes {
    // abstract method
	return nil;
}

/**
 * @abstract method, subclass must implement
 */
- (PhysicsObject *) initObjectWithKey:(NSString*)key {
    // abstract method
	return nil;
}


@end
