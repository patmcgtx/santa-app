//
//  RTSScreenGuide.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RTSDirection.h"

@interface RTSScreenGuide : NSObject

-(id) initWithScreenDimensions:(CGRect) dimensions;

/*
 Tells you which direction off the screen the point is, or
 RTSDirectionNone is the point is on the screen. 
 */
-(RTSDirection) directionTowardsPoint:(CGPoint) point;

@end
