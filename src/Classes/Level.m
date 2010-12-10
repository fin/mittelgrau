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
-(Level*) initWithBackground: (NSString*) backgroundPath {
	self = [self init];
	
	//set background and add to display tree
	SPImage *background = [SPImage imageWithContentsOfFile:backgroundPath];
	[background setY:24];
	[self addChild:background];
	
	BOOL blackCollisionMap[768][1024];
	BOOL whiteCollisionMap[768][1024];
	
	//initialize our collision maps

	/*
	for (int i = 0; i <= 767; i++) {
		for (int j = 0; j <= 1023; j++) {
			
			blackCollisionMap[i][j] = YES;
			whiteCollisionMap[i][j] = YES;
		}
	}*/
	UIImage *backdrop = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"level_0" ofType:@"png"]];
	[self getCollisionMapsFromImage:backdrop];
	
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

- (void)getCollisionMapsFromImage:(UIImage*)image
{
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
												 bitsPerComponent, bytesPerRow, colorSpace,
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
    
	
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
	
	int byteIndex = 0;
	for (int i = 0; i < height; i++) {
		for (int j = 0; j < width; j++) {
			
			CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
			CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
			CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
			byteIndex += 4;
			if ((red >= 1.0) && (green >= 1.0) && (blue >= 1.0)) {
				whiteCollisionMap[i][j] = YES;
			} else if ((red <= 0.0) && (green <= 0.0) && (blue <= 0.0)){
				blackCollisionMap[i][j] = YES;
			} else {
				whiteCollisionMap[i][j] = NO;
				blackCollisionMap[i][j] = NO;
			}
		}
	}
	free(rawData);
}
@end

