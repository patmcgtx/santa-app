//
//  RTSLocationProvider.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/15/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "RTSStartable.h"

//
// Basic interface to get the device location.
//
// This interface provides a way to potentially switch back to the
// old automatic location sensor if and when I can legally do it,
// or use a non-automatic, non-specific user prompt until then.
//
@protocol RTSLocationProvider <NSObject, RTSStartable>

-(CLLocation*) currentLocation;
-(NSString*) localizedDistanceLabelToLocation:(CLLocation*) otherLocation;

@end
