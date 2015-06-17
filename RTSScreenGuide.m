//
//  RTSScreenGuide.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RTSScreenGuide.h"

@interface RTSScreenGuide ()

@property (nonatomic) CGFloat minX;
@property (nonatomic) CGFloat minY;
@property (nonatomic) CGFloat maxX;
@property (nonatomic) CGFloat maxY;

@end

@implementation RTSScreenGuide

@synthesize minX = _minX;
@synthesize maxX = _maxX;
@synthesize minY = _minY;
@synthesize maxY = _maxY;

-(id) initWithScreenDimensions:(CGRect) dimensions {
    self = [super init];
    if (self) {
        _minX = dimensions.origin.x;    // i.e. 0
        _maxX = dimensions.size.width;  // i.e. 480
        _minY = dimensions.origin.y;    // i.e. 0
        _maxY = dimensions.size.height; // i.e. 320
    }
    return self;    
}

-(RTSDirection) directionTowardsPoint:(CGPoint) point {
  
    RTSDirection retval = RTSDirectionCenter;
    
    // Favor left/right over up-down
    if ( point.x < self.minX ) {
        retval = RTSDirectionLeft;
    }
    else if ( point.x > self.maxX ) {
        retval = RTSDirectionRight;
    }
    else if ( point.y < self.minY ) {
        retval = RTSDirectionDown;
    }
    else if ( point.y > self.maxY ) {
        retval = RTSDirectionUp;
    }
    
    return retval;
}

@end
