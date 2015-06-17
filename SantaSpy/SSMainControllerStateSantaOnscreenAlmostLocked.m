//
//  MainControllerStateSantaOnscreenAlmostLocked.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/12/12.
//
//

#import "SSMainControllerStateSantaOnscreenAlmostLocked.h"
#import "SSMainControllerStateSantaOffscreenRight.h"
#import "SSMainControllerStateDisabled.h"
#import "SSMainControllerStateSleeping.h"
#import "SSMainControllerStateSantaOffscreen.h"
#import "SSMainControllerStateSantaOffscreenLeft.h"
#import "SSMainControllerStateSantaOnscreenLocked.h"
#import "SSMainControllerStateSantaOnscreenNotLocked.h"
#import "SSMainControllerStateLocatingDevice.h"
#import "SSMainControllerStateLocationDisabled.h"
#import "RTSLog.h"

@implementation SSMainControllerStateSantaOnscreenAlmostLocked

-(void) execute:(SSMainViewController*) controller {
    
    LOG_STATE(@"almost locked : execute");
    
    [controller displayStatusLocalized:@"STATUS_LOCKING"];
    [controller turnOuterLockIndicator:YES];
}

-(SSMainControllerState*) santaOffscreen:(SSMainViewController*) controller {
    
    LOG_STATE(@"almost locked -> offscreen");
    
    // Turn off the indicator and pass on to the next state
    [controller turnOuterLockIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateSantaOffscreen sharedInstance];
}

-(SSMainControllerState*) santaOffscreenLeft:(SSMainViewController*) controller {
    
    LOG_STATE(@"almost locked -> offscreen left");
    
    // Turn off the indicator and pass on to the next state
    [controller turnOuterLockIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateSantaOffscreenLeft sharedInstance];
}

-(SSMainControllerState*) santaOffscreenRight:(SSMainViewController*) controller {
    
    LOG_STATE(@"almost locked -> offscreen right");
    
    // Turn off the indicator and pass on to the next state
    [controller turnOuterLockIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateSantaOffscreenRight sharedInstance];
}

-(SSMainControllerState*) santaOnscreenNotlocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"almost locked -> onscreen, not locked");
    
    // Turn off the indicator and pass on to the next state
    [controller turnOuterLockIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateSantaOnscreenNotLocked sharedInstance];
}

-(SSMainControllerState*) santaOnscreenNearlylocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"almost locked -> same");
    
    // Already in this state
    return self;
}

-(SSMainControllerState*) santaOnscreenLocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"almost locked -> locked");
    
    // No need to turn off the indicator in this case
    [controller clearStatus];
    return [SSMainControllerStateSantaOnscreenLocked sharedInstance];
}

-(SSMainControllerState*) hibernate:(SSMainViewController*) controller {
    
    LOG_STATE(@"almost locked -> sleep");
    
    // Turn off the indicator and pass on to the next state
    [controller turnOuterLockIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateSleeping sharedInstance];
}

-(SSMainControllerState*) locating:(SSMainViewController*) controller {
    LOG_STATE(@"almost locked -> locating");
    [controller turnOuterLockIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateLocatingDevice sharedInstance];
}

-(SSMainControllerState*) disable:(SSMainViewController*) controller {
    
    LOG_STATE(@"almost locked -> disabled");
    
    // Turn off the indicator and pass on to the next state
    [controller turnOuterLockIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateDisabled sharedInstance];
}

-(SSMainControllerState*) locationDisabled:(SSMainViewController*) controller {
    LOG_STATE(@"almost locked -> location disabled");
    [controller turnOuterLockIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateLocationDisabled sharedInstance];
}

#pragma mark - Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static SSMainControllerStateSantaOnscreenAlmostLocked* sSharedInstance = nil;


+(SSMainControllerStateSantaOnscreenAlmostLocked*) sharedInstance
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
