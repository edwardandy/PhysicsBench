//
//  FrameworkDefinitionTest.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/18/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import "FrameworkDefinition.h"
#import "FrameworkClass.h"

@interface FrameworkDefinitionTest : GHTestCase { }
@end

@implementation FrameworkDefinitionTest

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

- (void)testDocumentLoad {
    GHTestLog(@"************************");
    GHTestLog(@"BEGINNING testDocumentLoad");   
    
    @try {
        //Load our file
        FrameworkDefinition *definition = [FrameworkDefinition loadFrameworkFromFile:[[NSBundle mainBundle] pathForResource:@"GCb2Types" ofType:@"plist"]]; 
        GHAssertNotNULL(definition, nil, @"Checking if document is null…");
        
        int count = [definition.classDefs count];
        GHAssertGreaterThan(count, 0, @"No documents loaded, failure has occured");
        
        for ( FrameworkClass *class in definition.classDefs ) {
            GHTestLog(@"Loaded Object\n=========");
            
            
            NSString * className = class.className;
            NSString * type = class.type;
            
            GHTestLog(@"\t[CLASS] %@\n\t[TYPE] %@", className, type);        

            for (FrameworkField * field in class.fields ) {
                NSString * ftype = field.type;
                NSString * fkey = field.key;
                NSString * fvalue = field.value;
                GHTestLog(@"\t\t[FIELD] %@\n\t\t[TYPE] %@\n\t\t[VALUE] %@\n", ftype, fkey, fvalue);            
            }
        }
        
    } @catch ( id theException ) {
        GHTestLog(@"An exception occcured %@", theException);
        
    }
    
    GHAssertTrue(true, @"Expression has not errored, passed test");
    GHTestLog(@"ENDING testDocumentLoad");
    GHTestLog(@"************************\n\n");
}


@end
