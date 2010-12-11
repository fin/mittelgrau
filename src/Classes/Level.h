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
#import "UIColor-Expanded.h"

@class Level;

@interface Level : SPSprite {
	SPImage *backgroundImage;
	Player *blackplayer;
    Player *whiteplayer;
    
    PlayerControl *control_black;
    PlayerControl *control_white;
	
@private
	BOOL blackCollisionMap[768][1024];
	BOOL whiteCollisionMap[768][1024];
}
- (Level*)initWithBackground: (NSString*)backgroundPath;
- (void)getCollisionMapsFromImage: (UIImage*)image;
- (BOOL)collides:(SPSprite *)s isBlack:(BOOL)b;

- (void)removePlayerControl;

- (PlayerControl *)getControlForEvent:(SPTouch *)e;
- (void)setControl:(PlayerControl *)ctl forEvent:(SPTouch *)e;
- (BOOL)eventIsBlack:(SPTouch *)e;

@property(retain) Player *blackplayer;
@property(retain) Player *whiteplayer;
@property(retain) PlayerControl *control_black;
@property(retain) PlayerControl *control_white;

@end
