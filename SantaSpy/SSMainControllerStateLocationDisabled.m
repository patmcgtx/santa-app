//
//  SSMainControllerStateLocationDisabled.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/24/12.
//
//

#import "SSMainControllerStateLocationDisabled.h"
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
#import "RTSLog.h"

@implementation SSMainControllerStateLocationDisabled

-(void) execute:(SSMainViewController*) controller {
    
    LOG_STATE(@"location disabled : execute");
    
    [controller locationServiceDisabled];
}

//
// On the transitions out of sleeping state, we always want to
// wake up the main controller.
//

-(SSMainControllerState*) santaOffscreen:(SSMainViewController*) controller {
    
    LOG_STATE(@"location disabled -> ofscreen");
    
    [controller clearStatus];
    return [SSMainControllerStateSantaOffscreen sharedInstance];
}

-(SSMainControllerState*) santaOffscreenLeft:(SSMainViewController*) controller {
    
    LOG_STATE(@"location disabled -> ofscreen left");
    
    [controller clearStatus];
    return [SSMainControllerStateSantaOffscreenLeft sharedInstance];
}

-(SSMainControllerState*) santaOffscreenRight:(SSMainViewController*) controller {
    
    LOG_STATE(@"location disabled -> ofscreen right");
    
    [controller clearStatus];
    return [SSMainControllerStateSantaOffscreenRight sharedInstance];
}

-(SSMainControllerState*) santaOnscreenNotlocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"location disabled -> onscreen, not locked");
    
    [controller clearStatus];
    return [SSMainControllerStateSantaOnscreenNotLocked sharedInstance];
}

-(SSMainControllerState*) santaOnscreenNearlylocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"location disabled -> nearly locked");
    
    [controller clearStatus];
    return [SSMainControllerStateSantaOnscreenAlmostLocked sharedInstance];
}

-(SSMainControllerState*) santaOnscreenLocked:(SSMainViewController*) controller {
    
    LOG_STATE(@"location disabled -> locked");
    
    [controller clearStatus];
    return [SSMainControllerStateSantaOnscreenLocked sharedInstance];
}

-(SSMainControllerState*) hibernate:(SSMainViewController*) controller {
    
    LOG_STATE(@"location disabled -> sleep");
    
    [controller clearStatus];
    return [SSMainControllerStateSleeping sharedInstance];
}

-(SSMainControllerState*) locating:(SSMainViewController*) controller {
    LOG_STATE(@"almost, not locked -> locating");
    [controller clearStatus];
    return [SSMainControllerStateLocatingDevice sharedInstance];
}

-(SSMainControllerState*) disable:(SSMainViewController*) controller {
    
    LOG_STATE(@"location disabled -> disabled");
    
    [controller clearStatus];
    return [SSMainControllerStateDisabled sharedInstance];
}

-(SSMainControllerState*) locationDisabled:(SSMainViewController*) controller {
    LOG_STATE(@"location disabled -> same");
    return self;
}


#pragma mark - Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static SSMainControllerStateLocationDisabled* sSharedInstance = nil;


+(SSMainControllerStateLocationDisabled*) sharedInstance
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
