//
//  PhysicsGrid.h
//  GraphicsCocos2d
//
//  Created by JONATHAN on 9/1/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "BaseGridView.h"

@class Document;

@interface PhysicsGrid : BaseGridView {	

@private
    Document    * _document;
    NSTimer     * _renderTimer;
}

@property (assign) __weak Document *_document;
@property (nonatomic, retain) NSTimer     * _renderTimer;

- (void) gridWithDocument:(Document*) newDocument;
- (void) performSelectorOnAllGraphics:(SEL)callback withTarget:(id)target;
@end

