//
//  SSLandmarkScreenMapper.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/10/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "RTSARLandmark.h"
#import "SSLandmarkChangeDelegate.h"

/**
 * This class tracks landmarks and figures out their proper
 * (x,y) position on the screen, based on current sensor data
 * such as device location and attitude.
 *
 * This is replacing the class RTSARLandmarkTransformer as part
 * of a refactoring effort.  While that class tracked multiple
 * landmarks, this one trcks only a single landmark.
 */
@interface SSLandmarkScreenMapper : NSObject

@property (nonatomic, strong) RTSARLandmark* landmark;
@property (nonatomic, weak) id<SSLandmarkChangeDelegate> delegate;

- (id)initWithBounds:(CGRect)boundsVal
      deviceLocation:(CLLocation*) deviceLoc
            landmark:(RTSARLandmark*) landmarkVal;


/*
 * Triggers this class to update its landmark's scrren pos, visibility, etc.
 * based on the latest sensor data.
 */
-(void) refreshLandmark;

/**
 * Notify of a new orientstion, which affects the point transformations
 */
-(void) changedInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

@end
