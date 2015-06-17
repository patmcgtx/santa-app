//
//  SSScanBar.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCocos2dSprite.h"

@interface SSScanBar : SSCocos2dSprite

- (id)initForLayer:(CCLayer*) layer;

-(CCTargetedAction*) sweepWithDuration:(ccTime) seconds;

/*
 Uncomment this to re-enable a streak behind the vertical bar (SANTA-34)
-(void) updateStreak;
*/

@end
