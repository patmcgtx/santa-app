//
//  SSMainControllerStateBase.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/12/12.
//
//

#import "SSMainControllerState.h"
#import "RTSLog.h"

@implementation SSMainControllerState

-(void) execute:(SSMainViewController*) controller {
    // Do nothing by default
    LOG_STATE(@"Do nothing");
}

-(SSMainControllerState*) santaOffscreen:(SSMainViewController*) controller {
    // Do nothing by default
    LOG_STATE(@"default -> offscreen");
    return self;
}

-(SSMainControllerState*) santaOffscreenLeft:(SSMainViewController*) controller {
    // Do nothing by default
    LOG_STATE(@"default -> offscreen left");
    return self;
}

-(SSMainControllerState*) santaOffscreenRight:(SSMainViewController*) controller {
    // Do nothing by default
    LOG_STATE(@"default -> offscreen right");
    return self;
}

-(SSMainControllerState*) santaOnscreenNotlocked:(SSMainViewController*) controller {
    // Do nothing by default
    LOG_STATE(@"default -> onscreen, not locked");
    return self;
}

-(SSMainControllerState*) santaOnscreenNearlylocked:(SSMainViewController*) controller {
    // Do nothing by default
    LOG_STATE(@"default -> onscreen, nearly locked");
    return self;
}

-(SSMainControllerState*) santaOnscreenLocked:(SSMainViewController*) controller {
    // Do nothing by default
    LOG_STATE(@"default -> onscreen, locked");
    return self;
}

-(SSMainControllerState*) hibernate:(SSMainViewController*) controller {
    // Do nothing by default
    LOG_STATE(@"default -> sleep");
    return self;
}

-(SSMainControllerState*) locating:(SSMainViewController*) controller {
    // Do nothing by default
    LOG_STATE(@"default -> locating");
    return self;
}

-(SSMainControllerState*) disable:(SSMainViewController*) controller {
    // Do nothing by default
    LOG_STATE(@"default -> onscreen, disabled");
    return self;
}

-(SSMainControllerState*) locationDisabled:(SSMainViewController*) controller {
    // Do nothing by default
    LOG_STATE(@"default -> locatoin disabled");
    return self;
}


@end
