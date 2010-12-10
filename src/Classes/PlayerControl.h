//
//  PlayerControl.h
//  mittelgrau
//
//  Created by fin del kind on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Sparrow.h>
#import <Player.h>

@interface PlayerControl : SPSprite {
	Player *player;
    SPPoint *touchPosition;
}

- (id) initWithPlayer:(Player*) p;

@property(retain) SPPoint *touchPosition;
@property(retain) Player *player;

@end
