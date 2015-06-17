//
//  SSMainControllerStateSantaOffscreenLeft.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/12/12.
//
//

#import "SSMainControllerStateSantaOffscreenLeft.h"
#import "SSMainControllerStateDisabled.h"
#import "SSMainControllerStateSleeping.h"
#import "SSMainControllerStateSantaOffscreen.h"
#import "SSMainControllerStateSantaOffscreenRight.h"
#import "SSMainControllerStateSantaOnscreenAlmostLocked.h"
#import "SSMainControllerStateSantaOnscreenLocked.h"
#import "SSMainControllerStateSantaOnscreenNotLocked.h"
#import "SSMainControllerStateLocatingDevice.h"
#import "SSMainControllerStateLocationDisabled.h"
#import "RTSLog.h"

@implementation SSMainControllerStateSantaOffscreenLeft

-(void) execute:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen left : execute");
    
    [controller displayStatusLocalized:@"STATUS_SCANNING"];
    [controller turnLeftDirectionIndicator:YES];
}

-(SSMainControllerState*) santaOffscreen:(SSMainViewController*) controller {

    LOG_STATE(@"offscreen left -> offscreen");
    
    // Turn off the left indicator and pass on to the next state
    [controller turnLeftDirectionIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateSantaOffscreen sharedInstance];
}

-(SSMainControllerState*) santaOffscreenLeft:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen left -> same");

    // Already in this state
    return self;
}

-(SSMainControllerState*) santaOffscreenRight:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen left -> offscreen right");
    
    // Turn off the left indicator and pass on to the next state
    [controller turnLeftDirectionIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateSantaOffscreenRight sharedInstance];
}

-(SSMainControllerState*) santaOnscreenNotlocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen left -> onscreen, not locked");

    // Turn off the left indicator and pass on to the next state
    [controller turnLeftDirectionIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateSantaOnscreenNotLocked sharedInstance];
}

-(SSMainControllerState*) santaOnscreenNearlylocked:(SSMainViewController*) controller {

    LOG_STATE(@"offscreen left -> onscreen, nearly locked");
    
    // Turn off the left indicator and pass on to the next state
    [controller turnLeftDirectionIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateSantaOnscreenAlmostLocked sharedInstance];
}

-(SSMainControllerState*) santaOnscreenLocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"offscreen left -> onscreen, locked");

    // Turn off the left indicator and pass on to the next state
    [controller turnLeftDirectionIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateSantaOnscreenLocked sharedInstance];
}

-(SSMainControllerState*) hibernate:(SSMainViewController*) controller {
    LOG_STATE(@"offscreen left -> sleep");
    // Turn off the left indicator and pass on to the next state
    [controller turnLeftDirectionIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateSleeping sharedInstance];
}

-(SSMainControllerState*) locating:(SSMainViewController*) controller {
    LOG_STATE(@"offscreen left -> locating");
    [controller turnLeftDirectionIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateLocatingDevice sharedInstance];
}

-(SSMainControllerState*) disable:(SSMainViewController*) controller {
    LOG_STATE(@"offscreen left -> disabled");
    // Turn off the left indicator and pass on to the next state
    [controller turnLeftDirectionIndicator:NO];
    [controller clearStatus];
    return [SSMainControllerStateDisabled sharedInstance];
}

-(SSMainControllerState*) locationDisabled:(SSMainViewController*) controller {
    LOG_STATE(@"offscreen left -> location disabled");
    [controller clearStatus];
    return [SSMainControllerStateLocationDisabled sharedInstance];
}

#pragma mark - Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static SSMainControllerStateSantaOffscreenLeft* sSharedInstance = nil;


+(SSMainControllerStateSantaOffscreenLeft*) sharedInstance
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
