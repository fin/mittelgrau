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
	[self setBackgroundImage:[SPImage imageWithContentsOfFile:backgroundPath]];
	[backgroundImage setY:24];
	[self addChild:backgroundImage];
	
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

	[self setStatusOverlay:[[StatusOverlay alloc] init]];
	[self addChild: statusOverlay];
	
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
    

    free(rawData);
}

- (void)onTouch:(SPTouchEvent *)event {
    NSArray *touches_started = [[event touchesWithTarget:self
									   andPhase:SPTouchPhaseBegan] allObjects];
    
    NSArray *touches_moved = [[event touchesWithTarget:self
									 andPhase:SPTouchPhaseMoved] allObjects];
	
    NSArray *touches_ended = [[event touchesWithTarget:self
									 andPhase:SPTouchPhaseEnded] allObjects];
    
    for(SPTouch *t in touches_ended) {
		SPPoint *cur = [t locationInSpace:self];
		if ([self getControlForEvent:t] != nil)  {
			if ([[self getControlForEvent:t] distanceToTouchPosition: cur] < 50) {
				[self removePlayerControl: t];
			}
		}
	}
    for(SPTouch *t in touches_started) {
        PlayerControl *pc = [self getControlForEvent:t];
		SPPoint *cur = [t locationInSpace:self];
		
		if ((([cur y] >= 924) || ([cur y] <= 100))
			&& (([cur x] >= 668) || ([cur x] <= 100)))
		{
			[whiteplayer toggleOrientation];
			[blackplayer toggleOrientation];
			[statusOverlay toggleOrientation];
		} else {
			if(pc==nil) {
				if ([self eventIsBlack:t]) {
					pc = [[PlayerControl alloc] initWithPlayer:[self blackplayer]];
					[pc setIsBlack:YES];
					[pc setTouchPosition:cur];
					[self setControl:pc];
				} else {
					pc = [[PlayerControl alloc] initWithPlayer:[self whiteplayer]];
					[pc setIsBlack:NO];
					[pc setTouchPosition:cur];
					[self setControl:pc];
				}
				
				SPPoint *loc = [t locationInSpace:self]; 
				[pc setX:[loc x]];
				[pc setY:[loc y]];
				[pc setTouchPosition:[SPPoint pointWithX:[loc x] y:[loc y]]];
			}
		}

		
    }
    for(SPTouch *t in touches_moved) {
        SPPoint *prev = [t previousLocationInSpace:self];
		SPPoint *cur = [t locationInSpace:self];
        if(prev==nil) {
            return;
        }
	
        if([self control_white] != nil && ![self eventIsBlack:t]) {
            if([[self control_white] touchPosition]!=nil){
				if (([SPPoint distanceFromPoint:cur toPoint:[[self control_white] touchPosition]] <= 100)
					|| ([SPPoint distanceFromPoint: cur toPoint: prev] < 200))
				{
					[[self control_white] setTouchPosition:cur];
				}
			} else {
				[[self control_white] setTouchPosition:cur];
			}
        }
        if([self control_black] != nil && [self eventIsBlack:t]){
            if(([[self control_black] touchPosition]!=nil)
				|| ([SPPoint distanceFromPoint: cur toPoint: prev] < 200))
			{
				if ([SPPoint distanceFromPoint:cur toPoint:[[self control_black] touchPosition]] <= 100) {
					[[self control_black] setTouchPosition:cur];
			}
			} else {
				[[self control_black] setTouchPosition:cur];
			}
        }
    }
}

- (BOOL)eventIsBlack:(SPTouch *)e {
	if ([[e locationInSpace:self] y] >= [backgroundImage height]/2) {
		return YES;
	} else {
		return NO;
	}
}

- (PlayerControl *)getControlForEvent:(SPTouch *)e {
	if ([self eventIsBlack:e]) {
        return control_black;
    }
    return control_white;
}

- (void)setControl:(PlayerControl *)ctl {
    if(ctl!=nil) {
        [self addChild:ctl];
		if ([ctl isBlack]) {
			[self setControl_black:ctl];
		} else {
			[self setControl_white:ctl];
		}
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
		[self removeChild:pc];
		if ([pc isBlack]) {
			[self setControl_black:nil];
		} else {
			[self setControl_white:nil];
		}
		//[pc dealloc]; //it's a bloody prototype
	}
	
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event {
    [self playerCollides:blackplayer isBlack:TRUE inFrame:event];
    [self playerCollides:whiteplayer isBlack:FALSE inFrame:event];
}

- (void)playerCollides:(Player *)player isBlack:(BOOL)b inFrame:(SPEnterFrameEvent*)event {
    Player_movement m = [player movementForFrame:event];
    if(m.x2 + [player width] > [self width]) {
        m.x2 = [self width] - [player width];
    }
    if(m.y2 + [player height] > [self height]) {
        m.y2 = [self height] - [player height];
    }
    if(m.x2<0) {
        m.x2 = 0;
    }
    if(m.y2<0) {
        m.y2 = 0;
    }

    
    BOOL steep = abs(m.y2 - m.y1) > abs(m.x2 - m.x1);
    if(steep) {
        int tmp = m.y1;
        m.y1 = m.x1;
        m.x1 = tmp;
        tmp = m.y2;
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
    for(int x=m.x1; x!=m.x2; x+=inc) {
        if(collision)
            break;
        
                    // (steep?y:x)][(steep?x:y)
                    // xcorner*(int)[player width]+
                    // ycorner*(int)[player height]+
        
        BOOL cl, cr, ct, cb;
        cl = [self pointCollidesX:(steep?y:x) andY:(steep?x:y)+[player height]/2 isBlack:b];
        cr = [self pointCollidesX:(steep?y:x)+[player width] andY:(steep?x:y)+[player height]/2 isBlack:b];
        ct = [self pointCollidesX:(steep?y:x)+[player width]/2 andY:(steep?x:y) isBlack:b];
        cb = [self pointCollidesX:(steep?y:x)+[player width]/2 andY:(steep?x:y)+[player height] isBlack:b];
        if(cl || cr || ct || cb) {
            collision = true;
            if(cr && !steep && deltax>0) {
                [player setDeltaX:0];
            }
            if(cl && !steep && deltax<0) {
                [player setDeltaX:0];
            }
            if(ct && steep && deltax>0) {
                [player setDeltaY:0];
            }
            if(cb && steep && deltax<0) {
                [player setDeltaY:0];
            }
            continue;
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

- (BOOL)pointCollidesX:(int)x andY:(int)y isBlack:(BOOL)b {
    return (b?blackCollisionMap:whiteCollisionMap)[x][y];
    
}

@synthesize blackplayer;
@synthesize whiteplayer;
@synthesize control_black;
@synthesize control_white;
@synthesize backgroundImage;
@synthesize statusOverlay;

@end

