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

        [levels addObject:@"level_0.png"];
        [levels addObject:@"level_1.png"];
		[levels addObject:@"level_2.png"];
		[levels addObject:@"winning_screen.png"];
		
        [self advanceLevel:nil];
        
        SPSound *sound = [SPSound soundWithContentsOfFile:@"background.mp3"];
        channel = [sound createChannel];
        channel.volume = 0.6f;
        channel.loop = YES;
        
        [channel play];
	}
    return self;
}

- (void)advanceLevel:(SPEvent *)event {
    NSLog(@"advance level: %d", levelno);
    if(levelno>=[levels count])
        return;
    if(current_level!=nil) {
        [self removeChild:current_level];
        [self removeEventListener:@selector(onTouch:) atObject:current_level
                   forType:SP_EVENT_TYPE_TOUCH];
    }

    current_level = [[Level alloc] initWithBackground:[levels objectAtIndex:levelno]];
    
    [self addChild:current_level];
    
    if(levelno+1==[levels count]) {
        NSLog(@"upcoming: last level");
        [self addEventListener:@selector(clickOnLastLevel:) atObject:self
                   forType:SP_EVENT_TYPE_TOUCH];
    }
    [self addEventListener:@selector(onTouch:) atObject:current_level
               forType:SP_EVENT_TYPE_TOUCH];
    [current_level addEventListener:@selector(advanceLevel:) atObject:self forType:@"LEVEL_DONE"];
    levelno++;
}

- (void)clickOnLastLevel:(SPEvent *)event {
    NSLog(@"click on last level");
    [self removeEventListener:@selector(clickOnLastLevel:) atObject:self
                   forType:SP_EVENT_TYPE_TOUCH];
    levelno=0;
    [self advanceLevel:nil];
    return;
}

- (void) dealloc {
    NSLog(@"dealloc: level");
    [levels release];
    [channel release];
    [super dealloc];
}





@end
