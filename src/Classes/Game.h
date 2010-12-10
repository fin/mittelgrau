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

@interface Game : SPStage {
    Player *blackplayer;
    Player *whiteplayer;
}

@property(retain) Player *blackplayer;
@property(retain) Player *whiteplayer;
@end
