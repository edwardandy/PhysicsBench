//
//  DocNode.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/10/10.
//  Copyright (c) 2010 Personal. All rights reserved.
//

#import "WorkspaceObject.h"

// Class Definition
@interface DocNode : NSTreeNode {

@public
    NSString                *nodeTitle;
    WorkspaceObject         *contents;
    NSImage                 *nodeIcon;
@private
    
}


// Property Identifies
@property (nonatomic, retain) NSImage           *nodeIcon;
@property (nonatomic, retain) NSString          *nodeTitle;
@property (nonatomic, retain) WorkspaceObject   *contents;


@end
