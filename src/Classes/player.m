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
- (Player *)initWithBW:(int)isBlack;

@end

// --- class implementation ------------------------------------------------------------------------

@implementation Player

- (id)init {
    if (self = [super init]) {
        [self setupSprite];        
    }
	[self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
	
    [self setDeltaX:10];
    
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
}

- (Player *)initWithBW:(int)isBlack {
    [self init];
    [self setImg:[SPImage imageWithContentsOfFile:(isBlack?@"player_facing_right_b.png":@"player_facing_right_w.png")]];
    [self addChild:[self img]];
    return self;
};

@synthesize img;
@synthesize orientation;
@synthesize deltaX;
@synthesize deltaY;


@end

