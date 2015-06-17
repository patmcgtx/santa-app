//
//  SSScanBar.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SSScanBar.h"

/*
 Uncomment this to re-enable a streak behind the vertical bar

@interface SSScanBar ()

@property (nonatomic, weak) CCMotionStreak* streak;

@end

 */

@implementation SSScanBar

//@synthesize streak = _streak;

- (id)initForLayer:(CCLayer*) layer
{
    self = [super initWithFile:@"ping-line.png" 
                      forLayer:layer 
                         atPos:ccp(-20, 160) // -20, 160 // Center, off-screen to the left; TODO calculate mid-Y instead of assume 320 (160 is centered vertically); need app window helper
                        atZPos:100
                          hide:NO];
    
    if (self) {
        /* To enable a streak behind the vertival bar; I never got it to cover the whole height of the screen (SANTA-34)
        _streak = [CCMotionStreak streakWithFade:0.5 minSeg:1.0 width:160.0 color:ccGREEN textureFilename:@"ping-line.png"];
        _streak.position = ccp(-20, 160);
        _streak.visible = YES;    
        _streak.fastMode = YES;
        [layer addChild:_streak z:100];
         */
        
        /* To enable shakes or waves on the vertical bar...
        CCWaves* waves = [CCWaves actionWithWaves:5 amplitude:20 horizontal:YES vertical:YES grid:ccg(15,10) duration:5];
        CCShaky3D* shaky = [CCShaky3D actionWithRange:4 shakeZ:NO grid:ccg(15,10) duration:5];        
        [self.sprite runAction:[CCRepeatForever actionWithAction:shaky]];
         */
    }
    return self;
}

-(CCTargetedAction*) sweepWithDuration:(ccTime) seconds {
    //CCMotionStreak
    CCPlace* startingPos = [CCPlace actionWithPosition:ccp(-20, 160)]; // TODO Dupl pos form init
    CCMoveTo* moveAcrossScreen = [CCMoveTo actionWithDuration:seconds position:ccp(490, 160)]; // TODO calculate pos off right of screen; see TODO in init
    return [self actionOnSelf:[CCSequence actions:startingPos, moveAcrossScreen, nil]];
}

/*
 Uncomment this to re-enable a streak behind the vertical bar (SANTA-34)
-(void) updateStreak {
    _streak.position = self.sprite.position;
}
 */

@end
