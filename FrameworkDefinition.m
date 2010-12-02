//
//  FrameworkDefinition.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/4/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "FrameworkDefinition.h"
#import "FrameworkClass.h"

@implementation FrameworkDefinition

@synthesize classDefs;


- (id) initWithSet:(NSSet*)defSet {
	self = [super init];
	if (self != nil) {
		classDefs = [[NSSet alloc] initWithSet:defSet];
	}
	return self;	
}

- (void) dealloc
{
	[classDefs release];
	[super dealloc];
}


@end
