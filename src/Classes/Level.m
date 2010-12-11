//
//  Level.m
//  mittelgrau
//
//  Created by Michael Emhofer on 10.12.10.
//  Copyright 2010 TU Wien. All rights reserved.
//

#import "Level.h"
#import "Player.h"


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
	
	[self setWhiteplayer:[[Player alloc] initWithIsBlack: 0]];
	[self setBlackplayer:[[Player alloc] initWithIsBlack: 1]];
	
	[self addChild:blackplayer];
	[self addChild:whiteplayer];

	[whiteplayer setX:100];
	
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
    int xx=0;
    int yy=0;

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

    int count = width*[image size].height;

    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    int x=xx;
    int y=yy;
    for (int ii = 0 ; ii < count ; ++ii)
    {
        CGFloat r   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat g = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat b  = (rawData[byteIndex + 2] * 1.0) / 255.0;
//        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;
        
        if(r<=0 && g <= 0 && b <= 0) {
            blackCollisionMap[x][y] = true;
        } else if (r>=1 && g>=1 && b >= 1) {
            whiteCollisionMap[x][y] = true;
        }
        x++;
        if(x>=width) {
            x=0;
            y++;
        }
    }
    
    NSLog(@"done");

    free(rawData);
}

- (void)onTouch:(SPTouchEvent *)event {
	NSLog(@" touches!");
	[blackplayer toggleOrientation];
	[whiteplayer toggleOrientation];
	
    NSArray *touches_started = [[event touchesWithTarget:self
												andPhase:SPTouchPhaseBegan] allObjects];
    
    NSArray *touches_moved = [[event touchesWithTarget:self
											  andPhase:SPTouchPhaseMoved] allObjects];
    
    NSArray *touches_ended = [[event touchesWithTarget:self
											  andPhase:SPTouchPhaseEnded] allObjects];
    
    for(SPTouch *t in touches_ended) {
        PlayerControl *pc = [self getControlForEvent:t];
        if(pc!=nil) {
            [self removeChild:pc];
            [self setControl:nil forEvent:t];
        }
    }
    for(SPTouch *t in touches_started) {
        PlayerControl *pc = [self getControlForEvent:t];
        if(pc==nil) {
            pc = [[PlayerControl alloc] initWithPlayer:[self eventIsBlack:t]?[self blackplayer]:[self whiteplayer]];
        }
        SPPoint *loc = [t locationInSpace:self];
        [pc setX:[loc x]];
        [pc setY:[loc y]];
        [pc setTouchPosition:[SPPoint pointWithX:[loc x] y:[loc y]]];
        [self setControl:pc forEvent:t];
    }
    for(SPTouch *t in touches_moved) {
        SPPoint *prev = [t previousLocationInSpace:self];
        if(prev==nil) {
            return;
        }
        if([self control_white] != nil && ![self eventIsBlack:t]) {
            if(([[self control_white] touchPosition]!=nil) &&
			   [SPPoint distanceFromPoint:[[self control_white] touchPosition] toPoint:prev] == 0) {
				[[self control_white] setTouchPosition:prev];
			}
        }
        if([self control_black] != nil && [self eventIsBlack:t]){
            if(([[self control_black] touchPosition]!=nil) &&
			   [SPPoint distanceFromPoint:[[self control_black] touchPosition] toPoint:prev] == 0) {
				[[self control_black] setTouchPosition:prev];
			}
        }
    }
}

- (BOOL)eventIsBlack:(SPTouch *)e {
    return [[e locationInSpace:self] y]<[self height]/2;
}

- (PlayerControl *)getControlForEvent:(SPTouch *)e {
    if ([self eventIsBlack:e]) {
        return control_black;
    }
    return control_white;
}

- (void)setControl:(PlayerControl *)ctl forEvent:(SPTouch *)e {
    if(ctl!=nil) {
        [self addChild:ctl];
    }
    if([self eventIsBlack:e]) {
        [self setControl_black:ctl];
    } else {
        [self setControl_white:ctl];
    }
}

- (BOOL)collides:(Player *)p isBlack:(BOOL)b {
    int x = [p x];
    int y = [p y];
    int width = [p width];
    int height = [p height];
        
    
    
    for(int i=0;i<width;i++) {
        for(int j=0;j<height;j++) {
            if((b?blackCollisionMap:whiteCollisionMap)[x+i][y+j]) {
                return TRUE;
            }
        }
    }
    return FALSE;
}

@synthesize blackplayer;
@synthesize whiteplayer;
@synthesize control_black;
@synthesize control_white;

@end

