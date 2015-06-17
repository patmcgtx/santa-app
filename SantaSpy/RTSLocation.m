//
//  RTSLocation.m
//  OverThere
//
//  Created by Patrick McGonigle on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RTSLocation.h"
#import "SSNotificationNames.h"
#import "RTSLog.h"
#import "SSErrorReporter.h"
#import "RTSDistanceHelper.h"

// TODO Check for hardware support and error cases...
// http://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CLLocationManager_Class/CLLocationManager/CLLocationManager.html#//apple_ref/doc/uid/TP40007125-CH3-SW29

@interface RTSLocation ()

@property (nonatomic,retain) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* lastKnownLocation;

@end


@implementation RTSLocation

@synthesize locationManager = _locationManager;
@synthesize lastKnownLocation = _lastKnownLocation;

#pragma mark Object lifecycle

-(id) initWithAccuracy:(CLLocationAccuracy) accuracy
        DistanceFilter:(CLLocationDistance) distanceFilter
{
    self = [super init];
    LOG_OBJ_LIFECYCLE(@"initWithDistanceFilter");
    
    if (self) {
        /* Removing even the possibility of automatic location services
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _lastKnownLocation = nil;        

        // We do not need an accurate location for this app!
        _locationManager.desiredAccuracy = accuracy;
        _locationManager.distanceFilter = distanceFilter;
         */
    }
    return self;
}

#pragma mark - Main methods

// Returns the current (very rough) location, or nil it the location
// has not yet been determined.
-(CLLocation*) currentLocation {
    
    /* Removing even the possibility of automatic location services
    LOG_TRACE(@"currentLocation");
    
    // This is nil until a location is received, including
    // approval from the user to get their location, so could be a while.
    // So we have to depend on locationManager:didUpdateToLocation:... 
    // below as a signal to let us know the lcoation is available.
    self.lastKnownLocation = [self.locationManager location];
    return self.lastKnownLocation;
     */
    return nil;
}

-(void) forgetCurrentLocation {
    self.lastKnownLocation = nil;
}

-(NSString*) localizedDistanceLabelToLocation:(CLLocation*) otherLocation
{
    return [RTSDistanceHelper localizedDistanceLabelFromLocation:self.lastKnownLocation
                                                      toLocation:otherLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    /*
    Removing even the possibility of automatic location services
    
    // CoreLocation may take a fews seconds to actually find your location.
    // When this method gets called, that is our signal that the location is ready.
    // It may be cached and may not be very accurate, but for our purposes in this
    // app, that is just fine.
    
    // Let other waiting classes know that the location is ready
    if ( ! self.lastKnownLocation ) {
        LOG_SENSOR(@"Got new location");
        [[NSNotificationCenter defaultCenter] postNotificationName:SSNotificationGotDeviceLocation
                                                            object:self];
        _lastKnownLocation = newLocation;
    }
     */
}    
    

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    // No sense gimping the app if it already has a location...
    if ( ! self.lastKnownLocation ) {

        [[NSNotificationCenter defaultCenter] postNotificationName:SSNotificationLocationDisaled
                                                            object:nil];
    }
    
}

#pragma mark - Startable

-(void) start {
    [self.locationManager startMonitoringSignificantLocationChanges];
}


-(void) stop {
	[self.locationManager stopMonitoringSignificantLocationChanges];
}

@end
