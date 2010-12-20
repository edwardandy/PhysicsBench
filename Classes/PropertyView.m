//
//  PropertyView.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/19/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "PropertyView.h"
#import "FrameworkClass.h"

@interface PropertyView (PrivateMethods)
- (NSTextField*)createTextFieldWithRect:(NSRect)frameRect withString:(NSString*)title withFont:(NSFont*)cFont;
- (void)noResultsField;
@end


@implementation PropertyView

@synthesize titleFont, propertyFont, _currentViews;

/**
 * Standard initializaiton routine
 */
- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code here.
        _currentViews = [[NSMutableArray alloc] init];
        
        // Declare standard fonts that we will use throughout for this view
        titleFont    = [NSFont boldSystemFontOfSize:10.0f];
        propertyFont = [NSFont systemFontOfSize:10.0f];                     
        
        // Declare our title fonts
        NSRect fRect = NSMakeRect(5.0f, 5.0f, frame.size.width, 70.0);
        [self createTextFieldWithRect:fRect withString:@"Properties:" withFont:titleFont];
        
        // Declare 
        //[self noResultsField];
    }
    
    return self;
}

/**
 * Standard memory-management deallocation
 */
- (void)dealloc {
    // Clean-up code here.
    [_currentViews release];
    [titleFont release];
    [propertyFont release];
    [super dealloc];
}


#pragma mark -
#pragma mark NSView Delegate

/**
 * Change coordinate system from bottom,left to top,left. This
 * provides a convenient way of calculating additional fields
 */
- (BOOL)isFlipped {
    return YES;
}


#pragma mark -
#pragma mark Convenience methods

/**
 * Responsible for creating text fields throughout the properties tab
 */
- (NSTextField*)createTextFieldWithRect:(NSRect)frameRect withString:(NSString*)title withFont:(NSFont*)cFont{
    NSTextField *textField = [[NSTextField alloc] initWithFrame:frameRect];
    NSTextFieldCell *cell = [[NSTextFieldCell alloc] initTextCell:title];
    [cell setFont:cFont];
    [textField setCell:cell];
    [self addSubview:textField];
    
    return textField;
}

/**
 * Responsible for displaying a no properties
 */
- (void)noResultsField {
    NSRect fRect = NSMakeRect(_bounds.size.width/2-40, _bounds.size.height/2-20, _bounds.size.width-50, 25.0f);
    NSTextField *textField = [[NSTextField alloc] initWithFrame:fRect];
    NSTextFieldCell *cell = [[NSTextFieldCell alloc] initTextCell:@"No Properties"];
    
    NSFont *aFont = [NSFont fontWithName:@"Verdana" size:13.0f];
    [cell setFont:aFont];
    [cell setBezelStyle:NSTextFieldRoundedBezel];
    [cell setBackgroundColor:[NSColor colorWithDeviceRed:0.7 green:0.7 blue:0.7 alpha:0.4]]; 
    [textField setCell:cell];

    [self addSubview:textField];
}

/**
 * 
 */
- (void) displayAllProperties:(NSArray*)props {
    
    for (NSTextField *fd in _currentViews ) {
        [fd removeFromSuperview];
    }
    
    _currentViews = nil;
    _currentViews = [[NSMutableArray alloc] init];
    
    CGFloat x = 10.0;
    CGFloat y = 20.0;
    CGFloat width = 100.0;
    CGFloat height = 25.0;
    CGFloat spaceY = 20.0f;
    CGFloat minSpaceY = 10.0f;
    CGFloat spaceX = 10.0f;
    int i = 1;
    int j = 1;
    
    
    for (FrameworkClass *clazz in props ) {
        NSRect rect = NSMakeRect(x, y+(spaceY*i), width, height);
        NSTextField *fText = [self createTextFieldWithRect:rect withString:[clazz className] withFont:titleFont];    
        [_currentViews addObject:fText];
        i++;
        
        for (FrameworkField *field in clazz.fields ) {
            NSRect rect = NSMakeRect(x+spaceX, y+(spaceY*i), width, height);
            NSTextField *fText = [self createTextFieldWithRect:rect withString:[field key] withFont:titleFont];    
            [_currentViews addObject:fText];
            i++;
        }
        i++;
    }
    
}

@end
