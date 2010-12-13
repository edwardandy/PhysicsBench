//
//  WorkspaceObject.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/11/10.
//  Copyright (c) 2010 Personal. All rights reserved.
//

#import "BaseDrawableObject.h"

@protocol WorkspaceObject <NSObject>

@required
- (void) drawContentInWorkspaceContext:(CGContextRef)ctx;
@end

// Workspace objects are representations of any drawable objects
// that can be rendered and edited within the context of the IDE workspace. 
// This provides a uniform set of operations
// that are relevant within a workspace context such as selection, highlighting, drag
// and drop operations, etc...
//
// This is not a concrete class, objects wishing to render in a workspace context
// must subclass a workspace object 
@interface WorkspaceObject : BaseDrawableObject <WorkspaceObject> {
    
    BOOL			isVisible;
    BOOL			isSelected; 
    BOOL			isEditing;
    
@private	
        
}

// ************************* Properties ******************************
@property (assign) BOOL isVisible;
@property (assign) BOOL isSelected;
@property (assign) BOOL isEditing;
// ************************* Methods ******************************


@end
