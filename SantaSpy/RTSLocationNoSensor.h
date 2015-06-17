//
//  RTSLocationNoSensor.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/15/13.
//
//

#import "RTSLocation.h"
#import "RTSLocationProvider.h"

// This is a COPPA-compliant version of a locaiton tracker.
// It does not use a sensor / GPD to automatcailly detect your locaiton.
// It is simply *given* a conatsat location to hold onto and report back.
// The start/stop flow mimics what the sensor-based on does, except it
// looks up the saved location or prompt for it.
@interface RTSLocationNoSensor : NSObject <RTSLocationProvider>

+(RTSLocationNoSensor*) sharedInstance;

-(void) setNewLocation:(CLLocation*) newLoc;
-(void) setNewLabelForPlacemark:(CLPlacemark*) placemark;

// God, this is a bad back ;-/
@property (weak, nonatomic) UIViewController* mainViewController;

@end
