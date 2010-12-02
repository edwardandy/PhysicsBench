//
//  FrameworkClass.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/4/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FrameworkClass : NSObject {
	NSString		*className;
	NSString		*type;
	NSMutableSet	*fields;
}

// KVC compliant class


@property (nonatomic, retain) 	NSString		*className;
@property (nonatomic, retain) 	NSString		*type;
@property (nonatomic, retain) 	NSMutableSet	*fields;

@end


@interface FrameworkField : NSObject
{
	// Name
	NSString	*type;
	NSString	*key;
    NSString    *value;
}

// Properties
@property (nonatomic, retain) NSString	*type;
@property (nonatomic, retain) NSString  *key;
@property (nonatomic, retain) NSString  *value;

@end
