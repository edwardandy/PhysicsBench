//
//  BaseDrawableObject.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/10/10.
//  Copyright (c) 2010 Personal. All rights reserved.
//

#import <Quartz/Quartz.h>
#import <Cocoa/Cocoa.h>
#import "Workbench.h"


@interface BaseDrawableObject : CALayer <RenderLayer>{
@public    
    
    NSString    *objName;
    
    // Relative to coordinate space that
    // object is currently in
    NSSize      size;
    NSPoint     position;
    
    // Determine if needs to be rendered
    BOOL        needsRender;
    
@private
    
}

@property (nonatomic, retain)   NSString    *objName;
@property (assign)              NSSize       size;
@property (assign)              NSPoint      origin;
@property (assign)              BOOL        needsRender;

@end
