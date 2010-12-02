//
//  Document.m
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/1/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "Document.h"
#import "ChildNode.h"


@interface Document (PrivateMethods)
- (CALayer*) newLayer;
@end

NSString* DocumentDidUpdatePhysicsGroup = @"DocDidUpdatePhysicsGroup";

@implementation Document

@synthesize title, created, owner, physicsGroups, treeController, m_physicsGroups, rootLayer;

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
	[treeController release];
	[title release];
	[created release];
	[owner release];
	[physicsGroups release];
	[m_physicsGroups release];
	[super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    int value = [[change objectForKey:NSKeyValueChangeKindKey] intValue];
    NSIndexSet *set = [change objectForKey:NSKeyValueChangeIndexesKey];
    NSUInteger index = [set firstIndex];
    switch (value) {
        case NSKeyValueChangeInsertion: 
        {
            ChildNode * obj = [m_physicsGroups objectAtIndex:index];
            NSLog(@"class type %@", [obj nodeTitle]);
            

            [rootLayer addSublayer:[obj layer]];
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
