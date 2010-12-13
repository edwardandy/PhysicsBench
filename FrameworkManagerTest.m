//
//  FrameworkManagerTest.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/12/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import "FrameworkManager.h"

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

- (void) testFoo {
    NSString *a = @"foo";
    GHTestLog(@"I can log to the GHUnit test console: %@", a);
    
    // Assert a is not NULL, with no custom error description
    GHAssertNotNULL(a, nil);
    
    // Assert equal objects, add custom error description
    NSString *b = @"foo";
    GHAssertEqualObjects(a, b, @"A custom error message. a should be equal to: %@.", b);
}

@end
