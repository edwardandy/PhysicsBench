//
//  BaseDrawableObject.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/10/10.
//  Copyright (c) 2010 Personal. All rights reserved.
//

#import "Workbench.h"
#import <Quartz/Quartz.h>
#import <Cocoa/Cocoa.h>

@interface BaseDrawableObject : CALayer <RenderLayer>{
@public    
    
    NSString    *objName;
    
    // Relative to coordinate space that
    // object is currently in
    NSSize      d_size;
    NSPoint     d_origin;
    
    // Determine if needs to be rendered
    BOOL        needsRender;
    
@private
    
}

@property (nonatomic, retain)   NSString    *objName;
@property (assign)              NSSize       d_size;
@property (assign)              NSPoint      d_origin;
@property (assign)              BOOL        needsRender;

@end
