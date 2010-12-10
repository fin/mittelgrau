//
//  Level.h
//  mittelgrau
//
//  Created by Michael Emhofer on 10.12.10.
//  Copyright 2010 TU Wien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h" 

@interface Level : SPSprite {
	SPImage *backgroundImage;
}
- (Level*)initWithBackground: (NSString*)backgroundPath;

@end
