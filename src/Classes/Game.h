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

	StatusOverlay *statusOverlay;
}


@property(retain) StatusOverlay *statusOverlay;
@end
