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
        
	}
    return self;
}

- (void)onTouch:(SPTouchEvent *)event {
            NSLog(@" touches!");

    NSArray *touches = [[event touchesWithTarget:self
	    andPhase:SPTouchPhaseMoved] allObjects];
    
    if (touches.count >= 2) {
        NSLog(@"two touches!");
        SPTouch *touch1 = [touches objectAtIndex:0];
        SPTouch *touch2 = [touches objectAtIndex:1];
        
        SPPoint *currentPos1 = [touch1 locationInSpace:self];
        SPPoint *currentPos2 = [touch2 locationInSpace:self];
        
        [whiteplayer setdeltaX:([currentPos1 x] - [currentPos2 x])];
    }
}

@synthesize blackplayer;
@synthesize whiteplayer;
@end
