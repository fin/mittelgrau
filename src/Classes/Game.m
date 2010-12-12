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
        levelno = 0;
        levels = [[NSMutableArray alloc] init];
        [levels retain];
        
        [levels addObject:[[Level alloc] initWithBackground:@"level_0.png"]];
        [levels addObject:[[Level alloc] initWithBackground:@"level_1.png"]];
		
        [self advanceLevel:nil];
        
	}
    return self;
}

- (void)advanceLevel:(SPEvent *)event {
    if(levelno>0) {
        [self removeChild:[levels objectAtIndex:levelno-1]];
    }
    if(levelno>=[levels count]) {
        NSLog(@"it's over!");
        return;
    }
    Level *level = [levels objectAtIndex:levelno];
    [self addChild:level];
    [self addEventListener:@selector(onTouch:) atObject:level
               forType:SP_EVENT_TYPE_TOUCH];
    [level addEventListener:@selector(advanceLevel:) atObject:self forType:@"LEVEL_DONE"];
    levelno++;
}

- (void) dealloc {
    NSLog(@"dealloc: level");
    [levels release];
    [super dealloc];
}





@end
