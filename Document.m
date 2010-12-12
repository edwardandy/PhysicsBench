//
//  Document.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/1/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "Document.h"
#import "DocNode.h"

@interface Document (PrivateMethods)
- (CALayer*) newLayer;
@end

NSString* DocumentDidUpdatePhysicsGroup = @"DocDidUpdatePhysicsGroup";

@implementation Document

@synthesize title, created, owner, physicsGroups, m_physicsGroups, rootLayer;

// -------------------------------------------------------------------------------
//	init
//
//	Provide document standard properties on initialization
// -------------------------------------------------------------------------------
- (id) init
{
	self = [super init];
	if (self != nil) {
		title = @"";
		created = [NSDate date];
		owner = @"";

		
		
        rootLayer = [[CALayer alloc] init];
		// Create array and initialize default group
		m_physicsGroups = [[NSMutableArray alloc] init];		
        [self addObserver:self forKeyPath:@"m_physicsGroups" options:NSKeyValueObservingOptionNew context:nil];
	}
	return self;
}

// -------------------------------------------------------------------------------
//	dealloc
//
//	Yes, it's all about memory management!
// -------------------------------------------------------------------------------
- (void) dealloc
{
    [self removeObserver:self forKeyPath:@"m_physicsGroups"];
    [rootLayer release];
	[title release];
	[created release];
	[owner release];
	[physicsGroups release];
	[m_physicsGroups release];
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
            DocNode * obj = [m_physicsGroups objectAtIndex:index];
            NSLog(@"class type %@", [obj nodeTitle]);
            
            [rootLayer addSublayer:[obj contents]];
            break;
        }
        case NSKeyValueChangeRemoval:
        {
            CALayer *layer = [[rootLayer sublayers] objectAtIndex:index+1];
            [layer removeFromSuperlayer];
            break;
        }
            
    }
}

- (CALayer*) newLayer {
    return [[CALayer alloc] init];
    
}




@end
