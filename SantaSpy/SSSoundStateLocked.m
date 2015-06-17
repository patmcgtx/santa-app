//
//  SSSoundStateLocked.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/11/12.
//
//

#import "SSSoundStateLocked.h"
#import "SSSoundStateAlmostLocked.h"
#import "SSSoundStateNotLocked.h"
#import "SSSantaSounds.h"
#import "SSSoundPlayer.h"
#import "SSSantaTracker.h"

@implementation SSSoundStateLocked

-(void) play {
    
    // Always play some static over whatever sound Santa is making.
    // It's okay if it's alrady playing (nearly locked).
    [[SSSoundPlayer sharedInstance] startInterference];
    //[[SSSoundPlayer sharedInstance] startRadioChatter];
    
    SSSantaSounds* currentSounds =[[SSSantaTracker sharedInstance] currentSantaSounds];
    [currentSounds play];
}

-(SSSoundState*) santaNotLocked {
    
    // Play a quick "unlock" sound
    [[SSSoundPlayer sharedInstance] playClickOff];
    
    [[SSSoundPlayer sharedInstance] stopAllSounds];
    return [SSSoundStateNotLocked sharedInstance];
}

-(SSSoundState*) santaOnscreenNearlylocked {
    
    // Play a quick "unlock" sound
    [[SSSoundPlayer sharedInstance] playClickOff];
    
    [[SSSoundPlayer sharedInstance] stopAllSounds];
    return [SSSoundStateAlmostLocked sharedInstance];
}

-(SSSoundState*) santaOnscreenLocked {
    // No state change; nothing to do.
    return self;
}


#pragma mark - Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static SSSoundStateLocked* sSharedInstance = nil;


+(SSSoundStateLocked*) sharedInstance
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
