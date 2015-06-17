//
//  RTSLocation.h
//  OverThere
//
//  Created by Patrick McGonigle on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "RTSStartable.h"
#import "RTSLocationProvider.h"

@interface RTSLocation : NSObject <CLLocationManagerDelegate, RTSLocationProvider>

-(id) initWithAccuracy:(CLLocationAccuracy) accuracy
        DistanceFilter:(CLLocationDistance) distanceFilter;

// Tells this object to forget the current known location, and let us know
// when it find a new location.
-(void) forgetCurrentLocation;

@end
