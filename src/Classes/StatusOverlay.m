//
//  StatusOverlay.m
//  mittelgrau
//
//  Created by Michael Emhofer on 10.12.10.
//  Copyright 2010 TU Wien. All rights reserved.
//

#import "StatusOverlay.h"


// --- private interface ---------------------------------------------------------------------------

@interface StatusOverlay ()

- (void)setupSprite;

@end

// --- class implementation ------------------------------------------------------------------------

@implementation StatusOverlay

- (id)init {
    if (self = [super init]) {
        [self setupSprite];    
		gravityBarWhite = [SPImage imageWithContentsOfFile:@""];
    }
    return self;
}

- (void)setupSprite {
}

- (void)dealloc {
    [super dealloc];
}

@end

