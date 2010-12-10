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
	
    return self;
}

- (void)setupSprite {
}

- (void)dealloc {
    [super dealloc];
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event
{
    NSLog(@"Time passed since last frame: %f", event.passedTime);
//    [enemy moveBy:event.passedTime * enemy.velocity];
}

- (Player *)initWithBW:(int)isBlack {
    [self init];
    [self setImg:[SPImage imageWithContentsOfFile:@"player_facing_right_b.png"]];
    [self addChild:[self img]];
    return self;
};

@synthesize img;
@synthesize orientation;


@end

