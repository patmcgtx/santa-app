//
//  RTSMotion.m
//  OverThere
//
//  Created by Patrick McGonigle on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RTSMotion.h"
#import "RTSLog.h"
#import "SSTimingSettings.h"
#import "SSErrorReporter.h"
#import "SSNotificationNames.h"

// 30 hz, just a guess...
#define kRTSMotionUpdateInterval 0.05;

// TODO Check for hardware support and error cases...
// http://developer.apple.com/library/ios/documentation/CoreMotion/Reference/CMMotionManager_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40009670-CH1-SW37

@interface RTSMotion ()

@property (nonatomic, retain) CMMotionManager* motionManager;
@property (nonatomic) BOOL active;

@end


@implementation RTSMotion

@synthesize motionManager = _motionManager;
@synthesize active = _active;

#pragma mark Object lifecycle

-(id) init
{
    self = [super init];
    LOG_OBJ_LIFECYCLE(@"init");
    if (self) {
        _motionManager = [[CMMotionManager alloc] init];
        _active = NO;
        
        if ( ! _motionManager.magnetometerAvailable ) {
            [[SSErrorReporter sharedReporter] disableAppWithMessageKey:@"SENSOR_ERROR_MAGNETOMETER_NOT_AVAILABLE"
                                                                 error:nil
                                                             debugInfo:@"magnetometer not available"];
        }
        else if ( ! _motionManager.deviceMotionAvailable ) {
            [[SSErrorReporter sharedReporter] disableAppWithMessageKey:@"SENSOR_ERROR_MOTION_NOT_AVAILABLE"
                                                                 error:nil
                                                             debugInfo:@"device motion not available"];
        }
        
        // See https://developer.apple.com/library/ios/#documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/MotionEvents/MotionEvents.html#//apple_ref/doc/uid/TP40009541-CH4-SW18
        _motionManager.deviceMotionUpdateInterval = RTS_CORE_MOTION_UPDATE_INTERVAL;

        // Register for notifications
        // TODO turn the "hard" start/stop into a "soft" pause/resume
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stop)
                                                     name:SSNotificationMainViewDidPause
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(start)
                                                     name:SSNotificationMainViewWillResume
                                                   object:nil];
    }
    return self;
}

#pragma mark - Main methods

-(CMDeviceMotion*) currentMotion 
{
    return self.motionManager.deviceMotion;
}

-(void) reset {
    
    // Stop the current motion manager
    [self stop];
    
    // Get a new one
    _motionManager = [[CMMotionManager alloc] init];
    _motionManager.deviceMotionUpdateInterval = kRTSMotionUpdateInterval;
    
    // And kick it off
    [self start];
}

#pragma mark - Startable

-(void) start {
    LOG_APP_LIFECYCLE(@"start");
    
    if ( ! self.active) {
    
        // Tell CoreMotion to show the compass calibration HUD when required to provide true north-referenced attitude
        _motionManager.showsDeviceMovementDisplay = YES;
        
        // Note: This north-attitude requires iOS 5
        
        // Note: CMAttitudeReferenceFrameXTrueNorthZVertical doesn't work as expected, even when
        //       availableAttitudeReferenceFrames says it is available.  I think it has to do with
        //       getting the current location first.  For now, settling for magnetic north since
        //       it work well enough and does not requires current location first.
        /*
         if ([CMMotionManager availableAttitudeReferenceFrames] & CMAttitudeReferenceFrameXTrueNorthZVertical) {
         [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
         }
         else
         */
        if ([CMMotionManager availableAttitudeReferenceFrames] & CMAttitudeReferenceFrameXMagneticNorthZVertical) {
            
            // Just to make sure we have iOS 5...
            if ([_motionManager respondsToSelector:@selector(startDeviceMotionUpdatesUsingReferenceFrame:)]) {
                [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXMagneticNorthZVertical];
                LOG_SENSOR(@"Started device motion updates");
                self.active = YES;
            }
            else {
                // Can't run the app without a north heading!
                [[SSErrorReporter sharedReporter] disableAppWithMessageKey:@"IOS_NEEDS_UPGRADE"
                                                                     error:nil
                                                                 debugInfo:@"startDeviceMotionUpdatesUsingReferenceFrame not available"];
            }
        }
        else {
            // Can't run the app without a north heading!
            [[SSErrorReporter sharedReporter] disableAppWithMessageKey:@"SENSOR_ERROR_CANT_FIND_NORTH"
                                                                 error:nil
                                                             debugInfo:@"CMAttitudeReferenceFrameXMagneticNorthZVertical not available"];
        }
    }
}


-(void) stop {
    LOG_APP_LIFECYCLE(@"stop");

    if ( self.active ) {
        [_motionManager stopDeviceMotionUpdates];
        LOG_SENSOR(@"Stopped device motion updates");
        self.active = NO;
    }
}

#pragma mark Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static RTSMotion* sSharedInstance = nil;


+(RTSMotion*) sharedMotion
{
    if (sSharedInstance == nil) {
        sSharedInstance = [[super allocWithZone:NULL] init];
    }
    return sSharedInstance;
}


+(id) allocWithZone:(NSZone*) zone
{
    return [self sharedMotion];
}


-(id) copyWithZone:(NSZone*) zone
{
    return self;
}

@end
