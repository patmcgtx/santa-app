//
//  SSLandmarkChangeDelegate.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/10/12.
//
//

#import <Foundation/Foundation.h>
#import "RTSARLandmark.h"

/*
 * This protocol is called (ie by SSLandmarkScreenMapper) 
 * whenever a landmark's internal data (screen pos, etc.) 
 * is updated.  
 *
 * In this app, this happens effectively every 1 or seconds.
 */
@protocol SSLandmarkChangeDelegate <NSObject>

@required

-(void) landmarkWasUpdated:(RTSARLandmark*) landmarkVal;

@end
