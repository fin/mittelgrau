//
//  Item.m
//  mittelgrau
//
//  Created by fin del kind on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Item.h"


// --- private interface ---------------------------------------------------------------------------

@interface Item ()

- (void)setupSprite;

@end

// --- class implementation ------------------------------------------------------------------------

@implementation Item

- (id)initWithX:(int)x andY:(int)y {
    if (self = [super init]) {
        [self setupSprite];
        [self setX:x];
        [self setY:y];
    }
    return self;
}

- (void)setupSprite {
    img = [SPImage imageWithContentsOfFile:@"item.png"];
    img.x = (img.width/2)*-1;
    img.y = (img.height/2)*-1;
    [self addChild:img];
    [img retain];
}

- (void)dealloc {
    [img release];
    [super dealloc];
}

@end

