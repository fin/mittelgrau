//
//  PlayerControl.m
//  mittelgrau
//
//  Created by fin del kind on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayerControl.h"


// --- private interface ---------------------------------------------------------------------------

@interface PlayerControl ()

- (void)setupSprite;

@end

// --- class implementation ------------------------------------------------------------------------

@implementation PlayerControl

- (id)initWithPlayer:(Player *)p {
    if (self = [super init]) {
        [self setupSprite];        
    }
    [self setPlayer:p];
	
    SPImage *img = [SPImage imageWithContentsOfFile:@"controller.png"];
    [self addChild:img];
    [img setX:0-[self width]/2];
    [img setY:0-[self height]/2];
	
	[self setPosimg:[SPImage imageWithContentsOfFile:@"controller-position.png"]];
	[posimg setX:0-[posimg width]/2];
    [posimg setY:0-[posimg height]/2];
	[self addChild:posimg];
    
    return self;
}

- (void)setupSprite {
}

- (void)dealloc {
    [super dealloc];
}

- (void)setTouchPosition:(SPPoint *)p {

    touchPosition = p;
    
    SPPoint *p1 = [SPPoint pointWithX:[self x] y:[self y]];
    [self.posimg setX:[p x]-[self x]-[posimg width]/2];
    [player setDeltaX:([p x] - [p1 x])];
}

- (SPPoint *)touchPosition {
    return touchPosition;
}

@synthesize player;
@synthesize posimg;
@synthesize isBlack;

@end

