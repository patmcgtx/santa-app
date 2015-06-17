//
//  RTSLocationNoSensor.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/15/13.
//
//

#import "RTSLocationNoSensor.h"
#import "RTSDistanceHelper.h"
#import "SSErrorReporter.h"
#import "SSNotificationNames.h"
#import "SSSavedAppState.h"
#import "SSPlacemarkHelper.h"
#import "RTSLog.h"

@interface RTSLocationNoSensor ()

@property (strong, nonatomic) CLLocation* savedLocation;
@property (strong, nonatomic, readonly) NSString* savedPlacemarkLabel;

@end

@implementation RTSLocationNoSensor

@synthesize savedLocation = _savedLocation;
@synthesize mainViewController = _callingViewController;
@synthesize savedPlacemarkLabel = _savedPlacemarkLabel;

// Starts out with no location, only gets it on -start
- (id)init
{
    self = [super init];
    if (self) {
        _savedLocation = nil;
        _callingViewController = nil;
        _savedPlacemarkLabel = @"";
    }
    return self;
}

-(CLLocation*) currentLocation {    
    return self.savedLocation; // Might be nil, ie if -start was not called yet
}

-(NSString*) localizedDistanceLabelToLocation:(CLLocation*) otherLocation
{
    return [RTSDistanceHelper localizedDistanceLabelFromLocation:[self currentLocation]
                                                      toLocation:otherLocation];    
}

CLLocation* newLoc = nil;

-(void) setNewLabelForPlacemark:(CLPlacemark*) placemark {
    if ( placemark ) {
        _savedPlacemarkLabel = [SSPlacemarkHelper summaryLabelForPlacemark:placemark];

        SSSavedAppState* appState = [SSSavedAppState sharedInstance];
        appState.placemarkLabel = self.savedPlacemarkLabel;
    }
}


-(void) setNewLocation:(CLLocation*) newLoc {
    
    if ( newLoc ) {
        
        // Remember this as our working location
        self.savedLocation = newLoc;
        
        // Save it for future reference too
        SSSavedAppState* appState = [SSSavedAppState sharedInstance];
        appState.userLatitude = newLoc.coordinate.latitude;
        appState.userLongitude = newLoc.coordinate.longitude;

        // Follow flow of the sensor-based location service by sending the notification.
        // This will in turn cause a call to [self currentLocation].
        [[NSNotificationCenter defaultCenter] postNotificationName:SSNotificationGotDeviceLocation
                                                            object:self];
    }
}

#pragma mark - Startable

-(void) start {
    
    SSSavedAppState* appState = [SSSavedAppState sharedInstance];
    
    [self setNewLocation:[[CLLocation alloc] initWithLatitude:appState.userLatitude
                                                    longitude:appState.userLongitude]];
    
    // Otherwise prompt the user for it through a special view controller
    if ( ! self.savedLocation ) {

        if ( self.mainViewController ) {
            
            // We have to launch this form the main VC, which has (hopefully) been
            // provided through dependency injection earlier.
            [self.mainViewController performSegueWithIdentifier:@"main-to-place-prompt"
                                                            sender:self.mainViewController];
        }
        else {
            LOG_INTERNAL_ERROR(@"Error prompting for location info: no VC!");
        }
    }
}

-(void) stop {
    // No-op in this class
}

#pragma mark Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static RTSLocationNoSensor* sSharedInstance = nil;


+(RTSLocationNoSensor*) sharedInstance
{
    if (sSharedInstance == nil) {
        sSharedInstance = [[super allocWithZone:NULL] init];
    }
    return sSharedInstance;
}


+(id) allocWithZone:(NSZone*) zone
{
    return [self sharedInstance];
}


-(id) copyWithZone:(NSZone*) zone
{
    return self;
}

@end
