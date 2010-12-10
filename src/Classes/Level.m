//
//  Level.m
//  mittelgrau
//
//  Created by Michael Emhofer on 10.12.10.
//  Copyright 2010 TU Wien. All rights reserved.
//

#import "Level.h"


// --- private interface ---------------------------------------------------------------------------

@interface Level ()

- (void)setupSprite;
	
@end

// --- class implementation ------------------------------------------------------------------------

@implementation Level
-(Level*) background: (NSString*) backgroundPath {
	self = [super init];
	SPImage *background = [SPImage imageWithContentsOfFile:backgroundPath];
	[self addChild:background];
	return self;
}

- (id)init {
    if (self = [super init]) {
        [self setupSprite];
    }
    return self;
}

- (void)setupSprite {
}

- (void)dealloc {
    [super dealloc];
}

@end

