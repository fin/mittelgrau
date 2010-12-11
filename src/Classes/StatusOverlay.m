//
//  StatusOverlay.m
//  mittelgrau
//
//  Created by Michael Emhofer on 10.12.10.
//  Copyright 2010 TU Wien. All rights reserved.
//

#import "StatusOverlay.h"


// --- private interface ---------------------------------------------------------------------------

@interface StatusOverlay ()

- (void)setupSprite;

@end

// --- class implementation ------------------------------------------------------------------------

@implementation StatusOverlay

- (id)init {
    if (self = [super init]) {
        [self setupSprite];    
		[self setGravityBarWhite: [SPImage imageWithContentsOfFile:@"gravity_bar_white.png"]];
		[gravityBarWhite setY: 0];
		[self setGravityBarBlack: [SPImage imageWithContentsOfFile:@"gravity_bar_black.png"]];
		[gravityBarBlack setY: 1000];
		[self setX:0];
		[self setY:0];
		[self setWidth:768];
		[self setHeight:1024];
		[self addChild: gravityBarBlack];
		[self addChild: gravityBarWhite];
    }
    return self;
}

- (void)setupSprite {
}

- (void)dealloc {
    [super dealloc];
}
@synthesize gravityBarWhite;
@synthesize gravityBarBlack;
@end

