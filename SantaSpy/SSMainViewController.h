//
//  SSMainViewController.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SSFlipsideViewController.h"
#import "RTSPausable.h"
#import "SSErrorReporterFrontEnd.h"

@interface SSMainViewController : UIViewController
<SSFlipsideViewControllerDelegate, SSErrorReporterFrontEnd, UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// Callback for when the location is available
-(void) locationReady;

-(void) turnInnerLockIndicator:(BOOL) onOrOff;
-(void) turnOuterLockIndicator:(BOOL) onOrOff;
-(void) turnLeftDirectionIndicator:(BOOL) onOrOff;
-(void) turnRightDirectionIndicator:(BOOL) onOrOff;
-(void) turnActivityIndicator:(BOOL) onOrOff;

-(void) displayStatusLocalized:(NSString*) messageKey;
-(void) displayStatusLocalizedDistanceToSanta;
-(void) displayStatusLastKnownErrorLocalized;
-(void) clearStatus;

/*
 * To be called after transitioning to the sleeping state
 */
-(void) didGoToSleep;

/*
 * To be called when begine transition to the awake state
 */
-(void) willWakeUp;

/*
 * Tells this to start locking the current location, a process
 * which can take a few seconds.
 */
-(void) startFindingDeviceLocation;

/*
 * To be called when location services are discovered to be unavailable
 */
-(void) locationServiceDisabled;

@end
