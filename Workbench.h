//
//  Workbench.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/10/10.
//  Copyright (c) 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@protocol Workbench <NSObject>

@end


@protocol RenderLayer <NSObject>

@optional 
- (void) willDrawContentInContext:(CGContextRef)ctx;
- (void) didDrawContentInContext;

@required
-(void) drawContentInContext:(CGContextRef)ctx;

@end