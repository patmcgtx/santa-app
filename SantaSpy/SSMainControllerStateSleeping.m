//
//  SSMainControllerStateInactive.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/12/12.
//
//

#import "SSMainControllerStateSleeping.h"
#import "SSMainControllerStateSantaOnscreenLocked.h"
#import "SSMainControllerStateSantaOnscreenAlmostLocked.h"
#import "SSMainControllerStateSantaOffscreenRight.h"
#import "SSMainControllerStateDisabled.h"
#import "SSMainControllerStateSleeping.h"
#import "SSMainControllerStateSantaOffscreen.h"
#import "SSMainControllerStateSantaOffscreenLeft.h"
#import "SSMainControllerStateSantaOnscreenNotLocked.h"
#import "SSMainControllerStateLocatingDevice.h"
#import "SSMainControllerStateLocationDisabled.h"
#import "RTSLog.h"

@implementation SSMainControllerStateSleeping

-(void) execute:(SSMainViewController*) controller {
    
    LOG_STATE(@"sleeping : execute");
    
    // This is when we have started sleep mode
    [controller didGoToSleep];
}

//
// On the transitions out of sleeping state, we always want to
// wake up the main controller.
//

-(SSMainControllerState*) santaOffscreen:(SSMainViewController*) controller {
    
    LOG_STATE(@"sleeping -> offscreen");
    
    [controller willWakeUp];
    return [SSMainControllerStateSantaOffscreen sharedInstance];
}

-(SSMainControllerState*) santaOffscreenLeft:(SSMainViewController*) controller {
    
    LOG_STATE(@"sleeping -> offscreen left");
    
    [controller willWakeUp];
    return [SSMainControllerStateSantaOffscreenLeft sharedInstance];
}

-(SSMainControllerState*) santaOffscreenRight:(SSMainViewController*) controller {
    
    LOG_STATE(@"sleeping -> offscreen right");
    
    [controller willWakeUp];
    return [SSMainControllerStateSantaOffscreenRight sharedInstance];
}

-(SSMainControllerState*) santaOnscreenNotlocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"sleeping -> onscreen, not locked");
    
    [controller willWakeUp];
    return [SSMainControllerStateSantaOnscreenNotLocked sharedInstance];
}

-(SSMainControllerState*) santaOnscreenNearlylocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"sleeping -> onscreen, nearly locked");
    
    [controller willWakeUp];
    return [SSMainControllerStateSantaOnscreenAlmostLocked sharedInstance];
}

-(SSMainControllerState*) santaOnscreenLocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"sleeping -> locked");
    
    [controller willWakeUp];
    return [SSMainControllerStateSantaOnscreenLocked sharedInstance];
}

-(SSMainControllerState*) hibernate:(SSMainViewController *)controller {
    
    LOG_STATE(@"sleeping -> same");
    
    // We are already sleeping
    return self;
}

-(SSMainControllerState*) locating:(SSMainViewController*) controller {
    LOG_STATE(@"sleeping -> locating");
    [controller willWakeUp];
    return [SSMainControllerStateLocatingDevice sharedInstance];
}

-(SSMainControllerState*) disable:(SSMainViewController*) controller {
    
    LOG_STATE(@"sleep -> disabled");
    
    // Somehow wee got disabled while sleeping.  Not likely!
    return [SSMainControllerStateDisabled sharedInstance];
}

-(SSMainControllerState*) locationDisabled:(SSMainViewController*) controller {
    LOG_STATE(@"sleep -> location disabled");
    [controller willWakeUp];
    return [SSMainControllerStateLocationDisabled sharedInstance];
}

#pragma mark - Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static SSMainControllerStateSleeping* sSharedInstance = nil;


+(SSMainControllerStateSleeping*) sharedInstance
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
