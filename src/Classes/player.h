//
//  player.h
//  mittelgrau
//
//  Created by Michael Emhofer on 10.12.10.
//  Copyright 2010 TU Wien. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Sparrow.h>

@class Player;

typedef struct {
    int x1;
    int x2;
    int y1;
    int y2;
} Player_movement;


@interface Player : SPSprite {
	SPImage *img;
    int orientation;
    float deltaX;
    float deltaY;
    BOOL isBlack;
	int gravity;
}

- (Player *)initWithIsBlack:(int)b;
- (void) toggleOrientation;
- (Player_movement) movementForFrame:(SPEnterFrameEvent *)event;

@property (nonatomic, retain) SPImage *img;
@property (nonatomic) int orientation;
@property (nonatomic) float deltaX;
@property (nonatomic) float deltaY;
@property (nonatomic) BOOL isBlack;
@property (nonatomic) int gravity;

@end
