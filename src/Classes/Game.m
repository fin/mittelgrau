//
//  Game.m
//  AppScaffold
//
//  Created by Daniel Sperl on 14.01.10.
//  Copyright 2010 Incognitek. All rights reserved.
//

#import "Game.h"

@implementation Game

- (id)initWithWidth:(float)width height:(float)height
{
    if (self = [super initWithWidth:width height:height])
    {
		Level *level = [[Level alloc] initWithBackground:@"level_0.png"];
		[self addChild:level];
        
        [self setWhiteplayer:[[Player alloc] initWithBW:0]];
        [self setBlackplayer:[[Player alloc] initWithBW:1]];
        
        [self addChild:blackplayer];
        [self addChild:whiteplayer];
        
        [whiteplayer setX:100];
        
        [self addEventListener:@selector(onTouch:) atObject:self
	               forType:SP_EVENT_TYPE_TOUCH];
		[self setStatusOverlay:[[StatusOverlay alloc] init]];
		[self addChild: statusOverlay];
        
	}
    return self;
}

- (void)onTouch:(SPTouchEvent *)event {
            NSLog(@" touches!");

    NSArray *touches_started = [[event touchesWithTarget:self
	    andPhase:SPTouchPhaseBegan] allObjects];
    
    NSArray *touches_moved = [[event touchesWithTarget:self
	    andPhase:SPTouchPhaseMoved] allObjects];
    
    NSArray *touches_ended = [[event touchesWithTarget:self
	    andPhase:SPTouchPhaseEnded] allObjects];
    
    for(SPTouch *t in touches_ended) {
        PlayerControl *pc = [self getControlForEvent:t];
        if(pc!=nil) {
            [self removeChild:pc];
            [self setControl:nil forEvent:t];
        }
    }
    for(SPTouch *t in touches_started) {
        PlayerControl *pc = [self getControlForEvent:t];
        if(pc==nil) {
            pc = [[PlayerControl alloc] initWithPlayer:[self eventIsBlack:t]?[self blackplayer]:[self whiteplayer]];
        }
        SPPoint *loc = [t locationInSpace:self];
        [pc setX:[loc x]];
        [pc setY:[loc y]];
        [pc setTouchPosition:[SPPoint pointWithX:[loc x] y:[loc y]]];
        [self setControl:pc forEvent:t];
    }
    for(SPTouch *t in touches_moved) {
        SPPoint *prev = [t previousLocationInSpace:self];
        if(prev==nil) {
            return;
        }
        if([self control_white] != nil && ![self eventIsBlack:t]) {
            if(([[self control_white] touchPosition]!=nil) &&
                [SPPoint distanceFromPoint:[[self control_white] touchPosition] toPoint:prev] == 0) {
                    [[self control_white] setTouchPosition:prev];
                }
        }
        if([self control_black] != nil && [self eventIsBlack:t]){
            if(([[self control_black] touchPosition]!=nil) &&
                [SPPoint distanceFromPoint:[[self control_black] touchPosition] toPoint:prev] == 0) {
                    [[self control_black] setTouchPosition:prev];
                }
        }
    }
}

- (BOOL)eventIsBlack:(SPTouch *)e {
    return [[e locationInSpace:self] y]<[self height]/2;
}

- (PlayerControl *)getControlForEvent:(SPTouch *)e {
    if ([self eventIsBlack:e]) {
        return control_black;
    }
    return control_white;
}

- (void)setControl:(PlayerControl *)ctl forEvent:(SPTouch *)e {
    if(ctl!=nil) {
        [self addChild:ctl];
    }
    if([self eventIsBlack:e]) {
        [self setControl_black:ctl];
    } else {
        [self setControl_white:ctl];
    }
}

@synthesize blackplayer;
@synthesize whiteplayer;
@synthesize control_black;
@synthesize control_white;
@synthesize statusOverlay;
@end
