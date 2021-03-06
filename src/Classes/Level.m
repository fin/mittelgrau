//
//  Level.m
//  mittelgrau
//
//  Created by Michael Emhofer on 10.12.10.
//  Copyright 2010 TU Wien. All rights reserved.
//

#import "Level.h"
#import "Player.h"
#import "Item.h"

// --- private interface ---------------------------------------------------------------------------

@interface Level ()

- (void)setupSprite;
	
@end

// --- class implementation ------------------------------------------------------------------------

@implementation Level
-(Level*) initWithBackground: (NSString*) backgroundPath {
	self = [self init];	
    
    [self setBackdrop:[[SPSprite alloc] init]];
    [[self backdrop] setX:0];
    [[self backdrop] setY:24];
	[self addChild:backdrop];
    
	//set background and add to display tree
    backgroundImage = [SPImage imageWithContentsOfFile:backgroundPath];
	[backgroundImage setY:0];
    [backgroundImage retain];
	[[self backdrop] addChild:backgroundImage];
	
	[self setWhiteplayer:[[Player alloc] initWithIsBlack: 0]];
	[self setBlackplayer:[[Player alloc] initWithIsBlack: 1]];
    
    [[self blackplayer] setX:376];
    [[self whiteplayer] setX:376];
    
    SPSprite *player_container = [[SPSprite alloc] init];
    
	[player_container addChild:blackplayer];
	[player_container addChild:whiteplayer];

    [player_container setX:0];
    [player_container setY:24];
    
    [self addChild:player_container];
    	
    
    items = [[NSMutableArray alloc] init];
    
    for(int i=0;i<768;i++) {
        for(int j=0;j<1024;j++) {
            blackCollisionMap[i][j]=false;
            whiteCollisionMap[i][j]=false;
        }
    }
	
	UIImage *imgdata = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[backgroundPath substringToIndex:[backgroundPath length]-4]  ofType:@"png"]];
	[self getCollisionMapsFromImage:imgdata];
    
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
    [backdrop release];
    NSLog(@"dealloc level");
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
        else if(r<=0 && g>=1 && b <=0) {
            NSLog(@"found item at %d/%d", x, y);
            Item *i = [[Item alloc] initWithX:x andY:y];
            [[self backdrop] addChild:i];
            [items addObject:i];
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
    int i = 0;
    for(SPTouch *t in touches_ended) {
		i++;
		SPPoint *cur = [self locationInSpace:t];
		if ([self getControlForEvent:t] != nil)  {
			if ([[self getControlForEvent:t] distanceToTouchPosition: cur] < 100) {
				[self removePlayerControl: t];
			} else {
				PlayerControl* ctl = [self getControlForEvent:t];
				float x =  [[ctl touchPosition] x];
				float y = [[ctl touchPosition] y];
			}

		}
	}
    for(SPTouch *t in touches_started) {
        PlayerControl *pc = [self getControlForEvent:t];
		SPPoint *cur = [self locationInSpace:t]; //  [t locationInSpace:self];
		if ([statusOverlay checkToggleArea: cur])
		{
            [[SPSound soundWithContentsOfFile:@"grav_change_a.aif"] play];
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
				
				SPPoint *loc = [self locationInSpace:t]; 
				[pc setX:[loc x]];
				[pc setY:[loc y]];
				[pc setTouchPosition:[SPPoint pointWithX:[loc x] y:[loc y]]];
			} else {
				[pc setTouchPosition:cur];
			}

		}

		
    }
	i = 0;
    for(SPTouch *t in touches_moved) {
		i++;
        SPPoint *prev = [self previousLocationInSpace:t];
		SPPoint *cur = [self locationInSpace:t];
        if(prev==nil) {
			if ([self getControlForEvent:t] != nil) {
				[[self getControlForEvent:t] setTouchPosition:cur];
			}
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
				//[[self control_white] setTouchPosition:cur];
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
				//[[self control_black] setTouchPosition:cur];
			}
        }
    }
}

- (SPPoint *)locationInSpace:(SPTouch *)t {
    int y = [t globalY]-24;
    if(y<0)
        y=0;
    return [SPPoint pointWithX:[t globalX] y:y];
}

- (SPPoint *)previousLocationInSpace:(SPTouch *)t {
    int y = [t previousGlobalY]-24;
    if(y<0)
        y=0;
    return [SPPoint pointWithX:[t previousGlobalX] y:y];
}

- (BOOL)eventIsBlack:(SPTouch *)e {
	if ([[self locationInSpace:e] y] >= [backgroundImage height]/2) {
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
		[pc release]; //it's a bloody prototype
	}
	
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event {
    [self playerCollides:blackplayer isBlack:TRUE inFrame:event];
    [self playerCollides:whiteplayer isBlack:FALSE inFrame:event];
    NSMutableArray *toRemove = [[NSMutableArray alloc] init];
    for(Item *i in items) {
        SPPoint *p = [SPPoint pointWithX:[i x] y:[i y]];
        if([[[self blackplayer] bounds] containsPoint:p]) {
            [[SPSound soundWithContentsOfFile:@"bling_a.aif"] play];
            [backdrop removeChild:i];
            [toRemove addObject:i];
            continue; // prevent whiteplayer from getting it. unlikely, but possible.
        }
        if([[[self whiteplayer] bounds] containsPoint:p]) {
            [[SPSound soundWithContentsOfFile:@"bling_a.aif"] play];
            [backdrop removeChild:i];
            [toRemove addObject:i];
        }
    }
    for(Item *i in toRemove) {
        [items removeObject:i];
    }
    if([items count] == 0) {
        [self dispatchEvent:[SPEvent eventWithType:@"LEVEL_DONE"]];
    }
}

- (void)playerCollides:(Player *)player isBlack:(BOOL)b inFrame:(SPEnterFrameEvent*)event {
    Player_movement m = [player movementForFrame:event];
    int pwidth = [player width];
    int pheight = [player height];
    if(m.x2 + [player width] > [backgroundImage width]) {
        m.x2 = [backgroundImage width] - [player width];
    }
    if(m.y2 + [player height] > [backgroundImage height]) {
        m.y2 = [backgroundImage height] - [player height];
    }
    if(m.x2<0) {
        m.x2 = 0;
    }
    if(m.y2<0) {
        m.y2 = 0;
    }
    int y = m.y1;
    int xinc = abs(m.x2-m.x1)==0?0:(m.x2-m.x1)/abs(m.x2-m.x1);
    int yinc = abs(m.y2-m.y1)==0?0:(m.y2-m.y1)/abs(m.y2-m.y1);
    int x;
    for(x=m.x1;x!=m.x2;x+=xinc) {
        if ([self pointCollidesX:x+(xinc>0?pwidth:0) andY:y+(yinc>0?pheight:0)-yinc isBlack:b]) {
            break;
        }
        [player setX:x];
    }
    for(y=m.y1;y!=m.y2;y+=yinc) {
        if ([self pointCollidesX:x+(xinc>0?pwidth:0)-xinc andY:y+(yinc>0?pheight:0) isBlack:b]) {
            break;
        }
        [player setY:y];
    }
}

- (BOOL)pointCollidesX:(int)x andY:(int)y isBlack:(BOOL)b {
    return (b?blackCollisionMap:whiteCollisionMap)[x][y];
    
}

@synthesize blackplayer;
@synthesize whiteplayer;
@synthesize control_black;
@synthesize control_white;
@synthesize backdrop;
@synthesize statusOverlay;

@end

