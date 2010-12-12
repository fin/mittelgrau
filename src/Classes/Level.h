//
//  Level.h
//  mittelgrau
//
//  Created by Michael Emhofer on 10.12.10.
//  Copyright 2010 TU Wien. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sparrow.h" 
#import "Player.h"
#import "PlayerControl.h"
#import "StatusOverlay.h"

@class Level;

@interface Level : SPSprite {
	SPImage *backgroundImage;
	Player *blackplayer;
    Player *whiteplayer;
    
    PlayerControl *control_black;
    PlayerControl *control_white;
	StatusOverlay *statusOverlay;
    NSMutableArray *items;

@private
	BOOL blackCollisionMap[768][1024];
	BOOL whiteCollisionMap[768][1024];
}
- (Level*)initWithBackground: (NSString*)backgroundPath;
- (void)getCollisionMapsFromImage: (UIImage*)image;
- (BOOL)collides:(SPSprite *)s isBlack:(BOOL)b;

- (void)removePlayerControl:(SPTouch *)t;

- (PlayerControl *)getControlForEvent:(SPTouch *)e;
- (void)setControl:(PlayerControl *)ctl;
- (BOOL)eventIsBlack:(SPTouch *)e;
- (void)playerCollides:(Player *)player isBlack:(BOOL)b inFrame:(SPEnterFrameEvent*)event;
- (void)onEnterFrame:(SPEnterFrameEvent *)event;
- (BOOL)pointCollidesX:(int)x andY:(int)y isBlack:(BOOL)b;


@property(retain) Player *blackplayer;
@property(retain) Player *whiteplayer;
@property(retain) PlayerControl *control_black;
@property(retain) PlayerControl *control_white;
@property(retain) SPImage *backgroundImage;
@property(retain) StatusOverlay *statusOverlay;

@end
