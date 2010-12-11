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
	
	UIImage *backdrop = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"level_0" ofType:@"png"]];
	[self getCollisionMapsFromImage:backdrop];
    
    
    [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];

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
/*
    NSArray *touches_started = [[event touchesWithTarget:self
									   andPhase:SPTouchPhaseBegan] allObjects];
    
    NSArray *touches_moved = [[event touchesWithTarget:self
									 andPhase:SPTouchPhaseMoved] allObjects];
    
    NSArray *touches_ended = [[event touchesWithTarget:self
									 andPhase:SPTouchPhaseEnded] allObjects];
    
    for(SPTouch *t in touches_ended) {
        PlayerControl *pc = [self getControlForEvent:t];
        if(pc!=nil) {
			NSLog(@"pc not nil!!!");
            [self removeChild:pc];
			[pc dealloc];
            [self setControl:nil forEvent:t];
        }
    }
    for(SPTouch *t in touches_started) {
        PlayerControl *pc = [self getControlForEvent:t];
        if(pc==nil) {
            pc = [[PlayerControl alloc] initWithPlayer:[self eventIsBlack:t]?[self blackplayer]:[self whiteplayer]];
        
            SPPoint *loc = [t locationInSpace:self];
            [pc setX:[loc x]];
            [pc setY:[loc y]];
            [pc setTouchPosition:[SPPoint pointWithX:[loc x] y:[loc y]]];
            [self setControl:pc forEvent:t];
		}
    }
    for(SPTouch *t in touches_moved) {
        SPPoint *prev = [t previousLocationInSpace:self];
		SPPoint *cur = [t locationInSpace:self];
        if(prev==nil) {
            return;
        }
	
        if([self control_white] != nil && ![self eventIsBlack:t]) {
            if(([[self control_white] touchPosition]!=nil) &&
			   [SPPoint distanceFromPoint:cur toPoint:prev] <= 50) {
				[[self control_white] setTouchPosition:prev];
			} else {
				NSLog(@"distance: %f", [SPPoint distanceFromPoint:[[self control_white] touchPosition] toPoint:prev]);
				[self removePlayerControl: t];
			}

        }
        if([self control_black] != nil && [self eventIsBlack:t]){
            if(([[self control_black] touchPosition]!=nil) &&
			   [SPPoint distanceFromPoint: cur toPoint:prev] <= 50) {
				[[self control_black] setTouchPosition:prev];
			} else {
				NSLog(@"distance: %f", [SPPoint distanceFromPoint:[[self control_white] touchPosition] toPoint:prev]);
				[self removePlayerControl: t];
			}
        }
    }
 */
}

- (BOOL)eventIsBlack:(SPTouch *)e {
    return [[e locationInSpace:self] y]<[self height]/2;
}

- (PlayerControl *)getControlForEvent:(SPTouch *)e {
    NSLog(@"get control");
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

- (void)removePlayerControl:(SPTouch *)t {
	PlayerControl *pc = [self getControlForEvent:t];
	if(pc!=nil) {
		NSLog([self eventIsBlack:t]?@"removing white pc":@"removing black pc");
		[self removeChild:pc];
		[pc dealloc];
		[self setControl:nil forEvent:t];
		NSLog(@"done removing");
	}
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event {
    NSLog(@"FRAME!");
    [self playerCollides:whiteplayer isBlack:FALSE inFrame:event];
    [self playerCollides:blackplayer isBlack:TRUE inFrame:event];
}

- (void)playerCollides:(Player *)player isBlack:(BOOL)b inFrame:(SPEnterFrameEvent*)event {
    Player_movement m = [player movementForFrame:event];
    if(m.x2 + [player width] > [self width]) {
        m.x2 = [self width] - [player width];
    }
    if(m.y2 + [player height] > [self height]) {
        m.y2 = [self height] - [player height];
    }

    
    BOOL steep = abs(m.y2 - m.y1) > abs(m.x2 - m.x1);
    if(steep) {
        int tmp = m.x1;
        m.y1 = m.x1;
        m.x1 = tmp;
        tmp = m.x2;
        m.y2 = m.x2;
        m.x2 = tmp;
    }
    int deltax = abs(m.x2 - m.x1);
    int deltay = abs(m.y2 - m.y1);
    int error = deltax / 2;
    int ystep;
    int y = m.y1;
  
    int inc;
    if(m.x1 < m.x2){
        inc = 1;
    } else {
        inc = -1;
    }
 
    if(m.y1 < m.y2) {
        ystep = 1;
    } else {
        ystep = -1;
    }
    BOOL collision = FALSE;
    for(int x=m.x1; x<m.x2; x+=inc) {
        if(collision)
            break;
        for(int xcorner=0;xcorner<=1;xcorner++) {
            for(int ycorner=0;ycorner<=1;ycorner++) {
                if((b?blackCollisionMap:whiteCollisionMap)[xcorner*(int)[player width]+(steep?y:x)][ycorner*(int)[player height]+(steep?x:y)]) {
                    NSLog(@"COLLIDE! %d, %d", xcorner, ycorner);
                    collision=TRUE;
                    if(xcorner>0) {
                        [player setDeltaX:0];
                    }
                    if(ycorner>0) {
                        [player setDeltaY:0];
                    }
                    break;
                }
            }
        }
        // REM increment here a variable to control the progress of the line drawing
        error = error - deltay;
        if(error < 0) {
            y = y + ystep;
            error = error + deltax;
        }
        [player setX:(steep?y:x)];
        [player setY:(steep?x:y)];
    }
}

@synthesize blackplayer;
@synthesize whiteplayer;
@synthesize control_black;
@synthesize control_white;

@end

