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

@class PlayerControl;

@interface PlayerControl : SPSprite {
	Player *player;
    SPPoint *touchPosition;
	BOOL isBlack;
@private
	SPImage *posimg;
}

- (id) initWithPlayer:(Player *) p;
- (float) distanceToTouchPosition:(SPPoint *) p;

@property(retain) SPPoint *touchPosition;
@property(retain) Player *player;
@property(retain) SPImage *posimg;
@property BOOL isBlack;

@end
