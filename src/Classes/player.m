//
//  player.m
//  mittelgrau
//
//  Created by Michael Emhofer on 10.12.10.
//  Copyright 2010 TU Wien. All rights reserved.
//

#import "Player.h"


// --- private interface ---------------------------------------------------------------------------

@interface Player ()

- (void)setupSprite;

@end

// --- class implementation ------------------------------------------------------------------------

@implementation Player

- (id)init {
    if (self = [super init]) {
        [self setupSprite];        
    }
	
    [self setDeltaX:10];
	[self setY:100];
	[self setGravity: 100];
    
	[self setOrientation:[self isBlack]?-1:1];
	
    return self;
}

- (void)setupSprite {
}

- (void)dealloc {
    [super dealloc];
}

- (Player_movement) movementForFrame:(SPEnterFrameEvent *)event {
    Player_movement m;
    
    m.x1 = (int) [self x];
    m.x2 = (self.x + ceil(event.passedTime * deltaX));
    m.y1 = (int) [self y];
    m.y2 = (self.y + ceil(event.passedTime * self.gravity * orientation));
        
    return m;
}

- (Player *)initWithIsBlack:(int)b {
    [self init];
    [self setIsBlack:b];
    [self setImg:[SPImage imageWithContentsOfFile:(isBlack?@"player_facing_right_b.png":@"player_facing_right_w.png")]];
	if ([self isBlack] == 0) {
		[self toggleOrientation];
	}
    [self addChild:[self img]];
    return self;
}

- (void)toggleOrientation {
	if ([self orientation] == -1) {
		[self setOrientation: 1];
		[img setRotation:SP_D2R(0)];
		[img setY:0];
		[img setX:0];
	} else {
		[self setOrientation: -1];
		[img setRotation:SP_D2R(180)];
		[img setY: [img height]];
		[img setX: [img width]];
	}

}

@synthesize img;
@synthesize orientation;
@synthesize deltaX;
@synthesize deltaY;
@synthesize isBlack;
@synthesize gravity;

@end

