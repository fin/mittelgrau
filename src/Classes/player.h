//
//  player.h
//  mittelgrau
//
//  Created by Michael Emhofer on 10.12.10.
//  Copyright 2010 TU Wien. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Sparrow.h>

@interface Player : SPSprite {
	SPImage *img;
    int orientation;
    float deltaX;
    float deltaY;
    BOOL isBlack;

}

- (Player *)initWithIsBlack:(int)b;

@property (nonatomic, retain) SPImage *img;
@property (nonatomic) int orientation;
@property (nonatomic) float deltaX;
@property (nonatomic) float deltaY;
@property (nonatomic) BOOL isBlack;

@end
