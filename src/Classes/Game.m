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
        

        

        
        [self addEventListener:@selector(onTouch:) atObject:level
	               forType:SP_EVENT_TYPE_TOUCH];
        
	}
    return self;
}





@end
