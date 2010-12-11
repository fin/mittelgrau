//
//  Game.h
//  AppScaffold
//
//  Created by Daniel Sperl on 14.01.10.
//  Copyright 2010 Incognitek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h" 
#import "Level.h"
#import "Player.h"
#import "PlayerControl.h"
#import "StatusOverlay.h"

@interface Game : SPStage {
    Player *blackplayer;
    Player *whiteplayer;
    
    PlayerControl *control_black;
    PlayerControl *control_white;
	StatusOverlay *statusOverlay;
}

- (PlayerControl *)getControlForEvent:(SPTouch *)e;
- (void)setControl:(PlayerControl *)ctl forEvent:(SPTouch *)e;
- (BOOL)eventIsBlack:(SPTouch *)e;

@property(retain) Player *blackplayer;
@property(retain) Player *whiteplayer;
@property(retain) PlayerControl *control_black;
@property(retain) PlayerControl *control_white;
@property(retain) StatusOverlay *statusOverlay;
@end
