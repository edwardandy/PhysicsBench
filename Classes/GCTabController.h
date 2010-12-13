//
//  GCTabController.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/10/10.
//  Copyright (c) 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PhysicsGrid, Document;

@interface GCTabController : NSViewController {
@public	

    Document            *document;
@private	
	PhysicsGrid		*grid;


    
    
}

@property (nonatomic, assign) __weak Document *document;
@property (nonatomic, retain) 	PhysicsGrid *grid;


- (id) initWithView:(NSView*) view controller:(NSTreeController*)tController;


@end
