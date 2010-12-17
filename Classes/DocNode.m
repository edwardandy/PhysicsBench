//
//  DocNode.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/10/10.
//  Copyright (c) 2010 Personal. All rights reserved.
//

#import "DocNode.h"

@implementation DocNode

@synthesize nodeTitle, contents, nodeIcon, isLeaf;

/**
 * Standard initialization method
 */
- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
        [self setNodeTitle:@"LABEL_UNTITLED"];
        [self setIsLeaf:NO];
        [self addObserver:self forKeyPath:@"childNodes" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

/**
 * Standard init leaf method
 */
- (id)initLeaf
{
	if ((self = [self init])) {
		[self setIsLeaf:YES];
	}
	return self;
}

/**
 * Dealloc for memory management
 */
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"childNodes"];
    
    // Clean-up code here.
    [nodeIcon dealloc];
    [nodeTitle dealloc];
    [contents dealloc];
    [super dealloc];
}

/**
 * Key-value observing compliant. Essentially we are monitoring changes to make sure that
 * whatever we do will reflect on our rootlayer. This provides us a way of keeping our
 * layer tree in sync with our CALayer hiearchy since we cannot directly map the trees together
 */ 
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    int value = [[change objectForKey:NSKeyValueChangeKindKey] intValue];
    NSIndexSet *set = [change objectForKey:NSKeyValueChangeIndexesKey];
    NSUInteger index = [set firstIndex];
    switch (value) {
        case NSKeyValueChangeInsertion: 
        {
            
            DocNode * obj = [[self childNodes] objectAtIndex:index];
            NSLog(@"class type %@", [obj nodeTitle]);
            
            [contents addSublayer:[obj contents]];
            break;
        }
        case NSKeyValueChangeRemoval:
        {
            CALayer *layer = [[contents sublayers] objectAtIndex:index+1];
            [layer removeFromSuperlayer];
            break;
        }
            
    }
}

@end
