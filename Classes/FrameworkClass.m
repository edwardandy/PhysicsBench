//
//  FrameworkClass.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/4/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "FrameworkClass.h"


@implementation FrameworkClass

@synthesize className, type, fields;

- (id) init
{
	self = [super init];
	if (self != nil) {
		className = @"";
		type = @"";
		fields = [[NSMutableSet alloc] init];
	}
	return self;
}

- (void) dealloc
{
	[className release];
	[type release];
	[fields release];
	[super dealloc];
}


@end

#pragma mark -
#pragma mark FrameworkField 

@implementation FrameworkField 

@synthesize type, key, value;

- (id) init
{
	self = [super init];
	if (self != nil) {
		type = @"";
		key = @"";
        value = nil;
	}
	return self;
}

- (void) dealloc
{
    [value release];
	[type release];
	[key release];
	[super dealloc];
}




@end