//
//  SSMainControllerStateLocatingDevice.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/14/12.
//
//

#import "SSMainControllerStateLocatingDevice.h"
#import "SSMainControllerStateSleeping.h"
#import "SSMainControllerStateSantaOnscreenLocked.h"
#import "SSMainControllerStateSantaOnscreenAlmostLocked.h"
#import "SSMainControllerStateSantaOffscreenRight.h"
#import "SSMainControllerStateDisabled.h"
#import "SSMainControllerStateSleeping.h"
#import "SSMainControllerStateSantaOffscreen.h"
#import "SSMainControllerStateSantaOffscreenLeft.h"
#import "SSMainControllerStateSantaOnscreenNotLocked.h"
#import "SSMainControllerStateLocationDisabled.h"
#import "RTSLog.h"

@implementation SSMainControllerStateLocatingDevice

-(void) execute:(SSMainViewController*) controller {
    
    LOG_STATE(@"locating : execute");
    
    [controller clearStatus];
    [controller turnActivityIndicator:YES];
    [controller startFindingDeviceLocation];
}

//
// On the transitions out of sleeping state, we always want to
// wake up the main controller.
//

-(SSMainControllerState*) santaOffscreen:(SSMainViewController*) controller {
    
    LOG_STATE(@"locating -> offscreen");
    
    [controller turnActivityIndicator:NO];
    return [SSMainControllerStateSantaOffscreen sharedInstance];
}

-(SSMainControllerState*) santaOffscreenLeft:(SSMainViewController*) controller {
    
    LOG_STATE(@"locating -> offscreen left");
    
    [controller turnActivityIndicator:NO];
    return [SSMainControllerStateSantaOffscreenLeft sharedInstance];
}

-(SSMainControllerState*) santaOffscreenRight:(SSMainViewController*) controller {
    
    LOG_STATE(@"locating -> offscreen right");
    
    [controller turnActivityIndicator:NO];
    return [SSMainControllerStateSantaOffscreenRight sharedInstance];
}

-(SSMainControllerState*) santaOnscreenNotlocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"locating -> onscreen, not locked");
    
    [controller turnActivityIndicator:NO];
    return [SSMainControllerStateSantaOnscreenNotLocked sharedInstance];
}

-(SSMainControllerState*) santaOnscreenNearlylocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"locating -> onscreen, nearly locked");
    
    [controller turnActivityIndicator:NO];
    return [SSMainControllerStateSantaOnscreenAlmostLocked sharedInstance];
}

-(SSMainControllerState*) santaOnscreenLocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"locating -> locked");
    
    [controller turnActivityIndicator:NO];
    return [SSMainControllerStateSantaOnscreenLocked sharedInstance];
}

-(SSMainControllerState*) hibernate:(SSMainViewController *)controller {
    
    LOG_STATE(@"locating -> sleep");
    
    [controller turnActivityIndicator:NO];
    return [SSMainControllerStateSleeping sharedInstance];
}


-(SSMainControllerState*) locating:(SSMainViewController*) controller {
    LOG_STATE(@"locating -> same");
    return self;
}

-(SSMainControllerState*) disable:(SSMainViewController*) controller {
    
    LOG_STATE(@"locating -> disabled");
    
    // Somehow wee got disabled while sleeping.  Not likely!
    [controller turnActivityIndicator:NO];
    return [SSMainControllerStateDisabled sharedInstance];
}


-(SSMainControllerState*) locationDisabled:(SSMainViewController*) controller {
    LOG_STATE(@"locating -> location disabled");
    [controller turnActivityIndicator:NO];
    return [SSMainControllerStateLocationDisabled sharedInstance];
}

#pragma mark - Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static SSMainControllerStateLocatingDevice* sSharedInstance = nil;


+(SSMainControllerStateLocatingDevice*) sharedInstance
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
