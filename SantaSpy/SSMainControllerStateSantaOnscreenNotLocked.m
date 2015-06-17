//
//  SSMainControllerStateSantaOnscreenNotLocked.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/12/12.
//
//

#import "SSMainControllerStateSantaOnscreenNotLocked.h"
#import "SSMainControllerStateSantaOffscreen.h"
#import "SSMainControllerStateSantaOffscreenLeft.h"
#import "SSMainControllerStateDisabled.h"
#import "SSMainControllerStateSleeping.h"
#import "SSMainControllerStateSantaOffscreenRight.h"
#import "SSMainControllerStateSantaOnscreenAlmostLocked.h"
#import "SSMainControllerStateSantaOnscreenLocked.h"
#import "SSMainControllerStateLocatingDevice.h"
#import "SSMainControllerStateLocationDisabled.h"
#import "RTSLog.h"

@implementation SSMainControllerStateSantaOnscreenNotLocked

-(void) execute:(SSMainViewController*) controller {
    
    LOG_STATE(@"onscreen, not locked : execute");
    
    [controller displayStatusLocalized:@"STATUS_SCANNING"];
}

-(SSMainControllerState*) santaOffscreen:(SSMainViewController*) controller {
    
    LOG_STATE(@"onscreen, not locked -> ofscreen");
    
    [controller clearStatus];
    return [SSMainControllerStateSantaOffscreen sharedInstance];
}

-(SSMainControllerState*) santaOffscreenLeft:(SSMainViewController*) controller {
    
    LOG_STATE(@"onscreen, not locked -> ofscreen left");
    
    [controller clearStatus];
    return [SSMainControllerStateSantaOffscreenLeft sharedInstance];
}

-(SSMainControllerState*) santaOffscreenRight:(SSMainViewController*) controller {
    
    LOG_STATE(@"onscreen, not locked -> ofscreen right");
    
    [controller clearStatus];
    return [SSMainControllerStateSantaOffscreenRight sharedInstance];
}

-(SSMainControllerState*) santaOnscreenNotlocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"onscreen, not locked -> same");
    
    // Already in this state
    [controller clearStatus];
    return self;
}

-(SSMainControllerState*) santaOnscreenNearlylocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"onscreen, not locked -> nearly locked");
    
    [controller clearStatus];
    return [SSMainControllerStateSantaOnscreenAlmostLocked sharedInstance];
}

-(SSMainControllerState*) santaOnscreenLocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"onscreen, not locked -> locked");
    
    [controller clearStatus];
    return [SSMainControllerStateSantaOnscreenLocked sharedInstance];
}

-(SSMainControllerState*) hibernate:(SSMainViewController*) controller {
    
    LOG_STATE(@"onscreen, not locked -> sleep");
    
    [controller clearStatus];
    return [SSMainControllerStateSleeping sharedInstance];
}

-(SSMainControllerState*) locating:(SSMainViewController*) controller {
    LOG_STATE(@"almost, not locked -> locating");
    [controller clearStatus];
    return [SSMainControllerStateLocatingDevice sharedInstance];
}

-(SSMainControllerState*) disable:(SSMainViewController*) controller {
    
    LOG_STATE(@"onscreen, not locked -> disabled");
    
    [controller clearStatus];
    return [SSMainControllerStateDisabled sharedInstance];
}

-(SSMainControllerState*) locationDisabled:(SSMainViewController*) controller {
    LOG_STATE(@"onscreen, not locked -> location disabled");
    [controller clearStatus];
    return [SSMainControllerStateLocationDisabled sharedInstance];
}

//
// In all transitions, stay disabled.  You don't come back from being disabled.
// You are out for the game.  So fall back to default do-nothing implementation
// rather re-write them all here.
//

#pragma mark - Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static SSMainControllerStateSantaOnscreenNotLocked* sSharedInstance = nil;


+(SSMainControllerStateSantaOnscreenNotLocked*) sharedInstance
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
