//
//  FrameworkDefinition.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/4/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "FrameworkDefinition.h"
#import "FrameworkClass.h"

#define CLASS_DEF_ROOT @"ClassDef"

@implementation FrameworkDefinition

@synthesize classDefs, _classDictionary;

/**
 * Responsible for initializing a 
 */
- (id) initWithSet:(NSSet*)defSet {
	self = [super init];
	if (self != nil) {
		classDefs            = [[NSSet alloc] initWithSet:defSet];
        _classDictionary     = [[NSDictionary alloc] init];
	}
	return self;	
}

/**
 * Dealloc definition
 */
- (void) dealloc
{
    [_classDictionary release];
	[classDefs release];
	[super dealloc];
}

#pragma mark -
#pragma mark Delegation

/**
 * Returns any FrameworkClass loaded in our framework definitions 
 * with the key provided
 */
- (FrameworkClass*) classWithName:(NSString*)key {
    return [_classDictionary objectForKey:key];
}




@end
