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
}

- (Player *)initWithBW:(int)isBlack;

@property (nonatomic, retain) SPImage *img;
@property (nonatomic) int orientation;

@end
