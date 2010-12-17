//
//  FrameworkManagerTest.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/12/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import "Physics.h"
#import "FrameworkManager.h"
#import "FrameworkDefinition.h"
#import "Box2dFramework.h"
#import "GCb2Circle.h"

@interface FrameworkManagerTest : GHTestCase { }
@end

@implementation FrameworkManagerTest

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
    return NO;
}

- (void)setUp {
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

- (void) testCreatePhysicsObject {
    // Going with Default implementation
    id<Physics2dFramework> box2d = [[FrameworkManager sharedFrameworkManager] framework];
    PhysicsObject *pObj =  [box2d initObjectWithKey:@"Circle"];
    GHAssertNotNULL(pObj, nil);
    GHTestLog(@"Object not null");
    
    
    // Check if our objects match
    GHAssertTrue([pObj isKindOfClass:[GCb2Circle class]], @"Class should be equal to %@", @"GCb2Circle");
    GHTestLog(@"Object of correct type");
}


@end
