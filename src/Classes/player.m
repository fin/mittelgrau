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
	[self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
	
    [self setDeltaX:10];
	[self setY:100];
	[self setGravity: 100];
    
	[self setOrientation:1];
	
    return self;
}

- (void)setupSprite {
}

- (void)dealloc {
    [super dealloc];
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event
{
	[self setX: self.x + event.passedTime * deltaX];
	[self setY: self.y + event.passedTime * deltaY];
	[self setY: self.y + event.passedTime * self.gravity * orientation];
    
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

