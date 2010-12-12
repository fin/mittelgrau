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
		[self setOrientation:1];
    }
    return self;
}

- (void)setupSprite {
}

- (void)toggleOrientation {
	if ([self orientation] == -1) {
		[self setOrientation: 1];
		[gravityBarBlack setRotation:SP_D2R(0)];
		[gravityBarWhite setRotation:SP_D2R(0)];
		[gravityBarBlack setY:1000];
		[gravityBarBlack setX:0];
		[gravityBarWhite setY:0];
		[gravityBarWhite setX:0];
	} else {
		[self setOrientation: -1];
		[gravityBarBlack setRotation:SP_D2R(180)];
		[gravityBarWhite setRotation:SP_D2R(180)];
		[gravityBarBlack setY: 24];
		[gravityBarBlack setX: [gravityBarBlack width]];
		[gravityBarWhite setY: 1024];
		[gravityBarWhite setX: [gravityBarWhite width]];
	}
	
}

- (BOOL) checkToggleArea:(SPPoint *) p; {
	return ((([p y] >= 924) || ([p y] <= 100)) && (([p x] >= 668) || ([p x] <= 100)));
}

- (void)dealloc {
    [super dealloc];
}
@synthesize gravityBarWhite;
@synthesize gravityBarBlack;
@synthesize orientation;

@end

