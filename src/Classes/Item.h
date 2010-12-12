//
//  Item.h
//  mittelgrau
//
//  Created by fin del kind on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Sparrow.h>

@interface Item : SPSprite {

@private
    SPImage *img;
}

- (Item *)initWithX:(int)x andY:(int)y;

@end
