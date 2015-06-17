//
//  SSMainControllerStateSantaOffscreenRight.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/12/12.
//
//

#import "SSMainControllerStateSantaOffscreenRight.h"
#import "SSMainControllerStateDisabled.h"
#import "SSMainControllerStateSleeping.h"
#import "SSMainControllerStateSantaOffscreen.h"
#import "SSMainControllerStateSantaOffscreenLeft.h"
#import "SSMainControllerStateSantaOnscreenAlmostLocked.h"
#import "SSMainControllerStateSantaOnscreenLocked.h"
#import "SSMainControllerStateSantaOnscreenNotLocked.h"
#import "SSMainControllerStateLocatingDevice.h"
#import "SSMainControllerStateLocationDisabled.h"
#import "RTSLog.h"

@implementation SSMainControllerStateSantaOffscreenRight

-(void) execute:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen right : execute");
    
    [controller displayStatusLocalized:@"STATUS_SCANNING"];
    [controller turnRightDirectionIndicator:YES];
}

-(SSMainControllerState*) santaOffscreen:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen right -> offscreen");
    
    // Turn off the indicator and pass on to the next state
    [controller turnRightDirectionIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateSantaOffscreen sharedInstance];
}

-(SSMainControllerState*) santaOffscreenLeft:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen right -> ofscreen left");
    
    // Turn off the indicator and pass on to the next state
    [controller turnRightDirectionIndicator:NO];
    [controller clearStatus];
    [controller clearStatus];
    return [SSMainControllerStateSantaOffscreenLeft sharedInstance];
}

-(SSMainControllerState*) santaOffscreenRight:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen right -> same");
    
    // Already in this state
    return self;
}

-(SSMainControllerState*) santaOnscreenNotlocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen right -> onscreen, not locked");
    
    // Turn off the indicator and pass on to the next state
    [controller turnRightDirectionIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateSantaOnscreenNotLocked sharedInstance];
}

-(SSMainControllerState*) santaOnscreenNearlylocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen right -> onscreen, nearly locked");
    
    // Turn off the indicator and pass on to the next state
    [controller turnRightDirectionIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateSantaOnscreenAlmostLocked sharedInstance];
}

-(SSMainControllerState*) santaOnscreenLocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen right -> onscreen, locked");
    
    // Turn off the indicator and pass on to the next state
    [controller turnRightDirectionIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateSantaOnscreenLocked sharedInstance];
}

-(SSMainControllerState*) hibernate:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen right -> sleep");
    
    // Turn off the indicator and pass on to the next state
    [controller turnRightDirectionIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateSleeping sharedInstance];
}

-(SSMainControllerState*) locating:(SSMainViewController*) controller {
    LOG_STATE(@"offscreen right -> locating");
    [controller turnRightDirectionIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateLocatingDevice sharedInstance];
}

-(SSMainControllerState*) disable:(SSMainViewController*) controller {

    LOG_STATE(@"offscreen right -> disabled");
    
    // Turn off the indicator and pass on to the next state
    [controller turnRightDirectionIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateDisabled sharedInstance];
}

-(SSMainControllerState*) locationDisabled:(SSMainViewController*) controller {
    LOG_STATE(@"offscreen right -> location disabled");
    [controller clearStatus];
    return [SSMainControllerStateLocationDisabled sharedInstance];
}

#pragma mark - Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static SSMainControllerStateSantaOffscreenRight* sSharedInstance = nil;


+(SSMainControllerStateSantaOffscreenRight*) sharedInstance
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
