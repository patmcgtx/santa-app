//
//  KTCocos2dSprite.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SSCocos2dSprite.h"

@implementation SSCocos2dSprite

@synthesize sprite = _sprite;
@synthesize halfWidth = _halfWidth;
@synthesize imageName = _imageName;
@synthesize layer = _layer;
@synthesize startingPosition = _startingPosition;
@synthesize startingZPosition = _startingZPosition;
@synthesize startHidden = _startHidden;

- (id)initWithFile:(NSString*) imageFileName 
          forLayer:(CCLayer*) layer
             atPos:(CGPoint)pos
            atZPos:(int) zPos
              hide:(BOOL) hide {

    self = [super init];

    if (self) {        
        // Save these for later
        _layer = layer;
        _startingPosition = pos;
        _startingZPosition = zPos;
        _startHidden = hide;
        _imageName = imageFileName;
        
        // Set up the cocos2d sprite
        // (I would call [self reset], but I don't think you can do from insidee init.)
        _sprite = [CCSprite spriteWithFile:self.imageName];        
        _sprite.position = pos;
        _halfWidth = _sprite.contentSize.width / 2;        
        _sprite.visible = ! hide;
        
        // Add to the cocos2d layer
        [layer addChild:_sprite z:zPos];
    }
    
    return self;
}

- (CCTargetedAction*) actionOnSelf:(CCFiniteTimeAction*) action {
    return [CCTargetedAction actionWithTarget:self.sprite 
                                       action:action];    
}

-(CCTargetedAction*) showWithDelay:(float) delaySecs {
    CCShow* show = [CCShow action];
    CCDelayTime* wait = [CCDelayTime actionWithDuration:delaySecs];
    return [self actionOnSelf:[CCSequence actions:wait, show, nil]];
}

-(void) resetSprite {

    // Set the underlying sprite to a new, pristine state
    // ***without actually wiping it out and getting a new sprite object***.
    // If we wipeit out (like we used to), then all CCTargetedActions
    // previoulsly built on that sprite will now fail to run.
    
    // Stop the sprite in whatever it is doing
    [_sprite stopAllActions];
    
    // Set it back to how it started
    // One of the keys for this to work is that the balloon pop image (balloon-pop.png) 
    // is exactly the same size as the balloon image itself (e.g. balloon-blue.png)
    [_sprite setTexture:[[CCTextureCache sharedTextureCache] addImage:self.imageName]];
    _sprite.position = _startingPosition;
    _sprite.visible = ! _startHidden;
}

@end
