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

