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

- (void)setupSprite {
}

- (void)dealloc {
    NSLog(@"dealloc player, %@", isBlack?@"black":@"white");
    [super dealloc];
}

- (Player_movement) movementForFrame:(SPEnterFrameEvent *)event {
    Player_movement m;
    
    m.x1 = (int) [self x];
    m.x2 = (self.x + ceil(event.passedTime * deltaX));
    m.y1 = (int) [self y];
    m.y2 = ([self y] + (int)(event.passedTime * self.gravity * orientation));
    
    return m;
}

- (Player *)initWithIsBlack:(int)b {
    if (self = [super init]) {
        [self setupSprite];        
	
        [self setIsBlack:b];
		
		[self setY:isBlack?950:30];
		[self setGravity: 100];
		
		[self setFacingRight:[SPTexture textureWithContentsOfFile:(isBlack?@"player_facing_right_b.png":@"player_facing_right_w.png")]];
		[self setFacingLeft: [SPTexture textureWithContentsOfFile:(isBlack?@"player_facing_left_b.png":@"player_facing_left_w.png")]];
		[self setFacingFront: [SPTexture textureWithContentsOfFile:(isBlack?@"player_facing_front_b.png":@"player_facing_front_w.png")]];
		[self setDeltaX:0];
		[self setOrientation:1];
        if ([self isBlack] == 0) {
            [self toggleOrientation];
        }
		[self updateOrientation];
        
    }
    return self;
}

- (void)toggleOrientation {
	if ([self orientation] == -1) {
		[self setOrientation: 1];
	} else {
		[self setOrientation: -1];
	}
	[self updateOrientation];

}

- (void) updateOrientation {
	[self removeChild:[self img]];
	if (deltaX > 0) {
		[self setImg: [SPImage imageWithTexture:(orientation>0)?facingRight:facingLeft]];
	} else if (deltaX == 0) {
		[self setImg: [SPImage imageWithTexture:facingFront]];
	} else {
		[self setImg: [SPImage imageWithTexture:(orientation>0)?facingLeft:facingRight]];
	}
	if ([self orientation] == 1) {
		[img setRotation:SP_D2R(0)];
		[img setY:0];
		[img setX:0];
	} else {
		[img setRotation:SP_D2R(180)];
		[img setY: [img height]];
		[img setX: [img width]];
	}
	[self addChild:[self img]];
}

- (void)setDeltaX:(float) dx{
	deltaX = dx;
	[self updateOrientation];
	
		
}

@synthesize img;
@synthesize orientation;
@synthesize deltaX;
@synthesize deltaY;
@synthesize isBlack;
@synthesize gravity;
@synthesize facingRight;
@synthesize facingLeft;
@synthesize facingFront;

@end

