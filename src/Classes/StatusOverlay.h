//
//  StatusOverlay.h
//  mittelgrau
//
//  Created by Michael Emhofer on 10.12.10.
//  Copyright 2010 TU Wien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Sparrow.h>

@interface StatusOverlay : SPSprite {
	
@private
	SPImage *gravityBarWhite;
	SPImage *gravityBarBlack;
}

@property(retain) SPImage *gravityBarWhite;
@property(retain) SPImage *gravityBarBlack;
@end
