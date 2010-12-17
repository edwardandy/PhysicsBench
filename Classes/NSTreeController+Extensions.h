//
//  NSTreeController+Extensions.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 12/16/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSTreeController (NSTreeController_Extensions)
- (void)insertObject:(id)object;
- (void)insertChildObject:(id)object;
- (void)selectParentFromSelection;
@end
