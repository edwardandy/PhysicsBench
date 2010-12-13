//
//  GridDrawObject.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 10/11/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface GridDrawObject : CALayer {

	BOOL		isSelected;
	id			contents;
	
}

- (void) setIsSelected:(BOOL) value;

@end
