//
//  PropertyView.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/19/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface PropertyView : NSView {


    @private
        NSFont  *titleFont;
        NSFont  *propertyFont;
        NSMutableArray *_currentViews;
    
}

@property (nonatomic, retain) NSFont  *titleFont;
@property (nonatomic, retain) NSFont  *propertyFont;
@property (nonatomic, retain) NSMutableArray *_currentViews;


- (void) displayAllProperties:(NSArray*)props;

@end
