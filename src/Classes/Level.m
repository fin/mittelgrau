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
    
//	BOOL blackCollisionMap[(int)[background height]][(int)[background width]];
//	BOOL whiteCollisionMap[(int)[background height]][(int)[background width]];
    
    for(int i=0;i<768;i++) {
        for(int j=0;j<1024;j++) {
            blackCollisionMap[i][j]=false;
            whiteCollisionMap[i][j]=false;
        }
    }
	
	//initialize our collision maps

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
    int width = [image size].width;
    int height = [image size].height;
    
    NSArray *a = [self getRGBAsFromImage:image atX:0 andY:0 count:height*width];
	int byteIndex = 0;
    int x = 0;
    int y = 0;

    for(UIColor *c in a) {
        y = floor(byteIndex/width);
        x = byteIndex-(y*width);
        float r = [c red];
        float g = [c green];
        float b = [c blue];
        
        if(r<=0 && g <= 0 && b <= 0) {
            blackCollisionMap[x][y] = true;
        } else if (r>=1 && g>=1 && b >= 1) {
            whiteCollisionMap[x][y] = true;
        }
        byteIndex++;
    }
    NSLog(@"done");
}


- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];

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

    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ++ii)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;

        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }

  free(rawData);

  return result;
}

@end

