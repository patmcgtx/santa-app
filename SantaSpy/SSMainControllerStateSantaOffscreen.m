//
//  SSMainControllerStateSantaOffscreen.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/12/12.
//
//

#import "SSMainControllerStateSantaOffscreen.h"
#import "SSMainControllerStateSantaOffscreenLeft.h"
#import "SSMainControllerStateDisabled.h"
#import "SSMainControllerStateSleeping.h"
#import "SSMainControllerStateSantaOffscreenRight.h"
#import "SSMainControllerStateSantaOnscreenAlmostLocked.h"
#import "SSMainControllerStateSantaOnscreenLocked.h"
#import "SSMainControllerStateSantaOnscreenNotLocked.h"
#import "SSMainControllerStateLocatingDevice.h"
#import "SSMainControllerStateLocationDisabled.h"
#import "RTSLog.h"

@implementation SSMainControllerStateSantaOffscreen

-(void) execute:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen : execute");
    
    [controller displayStatusLocalized:@"STATUS_SCANNING"];
}

-(SSMainControllerState*) santaOffscreen:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen -> same");
    
    // Already in this state
    return self;
}

-(SSMainControllerState*) santaOffscreenLeft:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen -> offscreen left");
    [controller clearStatus];
    return [SSMainControllerStateSantaOffscreenLeft sharedInstance];
}

-(SSMainControllerState*) santaOffscreenRight:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen -> offscreen right");
    [controller clearStatus];
    return [SSMainControllerStateSantaOffscreenRight sharedInstance];
}

-(SSMainControllerState*) santaOnscreenNotlocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen -> onscreen, not locked");
    [controller clearStatus];
    return [SSMainControllerStateSantaOnscreenNotLocked sharedInstance];
}

-(SSMainControllerState*) santaOnscreenNearlylocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen -> onscreen, nearly locked");
    [controller clearStatus];
    return [SSMainControllerStateSantaOnscreenAlmostLocked sharedInstance];
}

-(SSMainControllerState*) santaOnscreenLocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen -> locked");
    [controller clearStatus];
    return [SSMainControllerStateSantaOnscreenLocked sharedInstance];
}

-(SSMainControllerState*) hibernate:(SSMainViewController*) controller {
    LOG_STATE(@"offscreen -> sleep");
    [controller clearStatus];
    return [SSMainControllerStateSleeping sharedInstance];
}

-(SSMainControllerState*) locating:(SSMainViewController*) controller {
    LOG_STATE(@"offscreen -> locating");
    [controller clearStatus];
    return [SSMainControllerStateLocatingDevice sharedInstance];
}

-(SSMainControllerState*) disable:(SSMainViewController*) controller {
    LOG_STATE(@"offscreen -> disabled");
    [controller clearStatus];
    return [SSMainControllerStateDisabled sharedInstance];
}

-(SSMainControllerState*) locationDisabled:(SSMainViewController*) controller {
    LOG_STATE(@"offscreen -> location disabled");
    [controller clearStatus];
    return [SSMainControllerStateLocationDisabled sharedInstance];
}


#pragma mark - Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static SSMainControllerStateSantaOffscreen* sSharedInstance = nil;


+(SSMainControllerStateSantaOffscreen*) sharedInstance
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
