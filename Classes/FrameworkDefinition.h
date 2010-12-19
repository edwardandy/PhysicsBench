//
//  FrameworkDefinition.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/4/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FrameworkClass;

@interface FrameworkDefinition : NSObject {
	NSSet               *classDefs;
    
    @private
        NSDictionary        *_classDictionary; 
}

@property (nonatomic, retain) NSDictionary   *_classDictionary;    
@property (readonly) NSSet          *classDefs;

- (id) initWithSet:(NSSet*)defSet;
- (FrameworkClass*) classWithName:(NSString*)key;

@end
