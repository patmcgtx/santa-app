//
//  SSSoundStateAlmostLocked.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/11/12.
//
//

#import "SSSoundStateLocked.h"
#import "SSSoundStateAlmostLocked.h"
#import "SSSoundStateNotLocked.h"
#import "SSSoundPlayer.h"

@implementation SSSoundStateAlmostLocked

-(void) play {
    //[[SSSoundPlayer sharedInstance] stopAllSounds];
    [[SSSoundPlayer sharedInstance] startSearchingStatic];
}

-(SSSoundState*) santaNotLocked {
    [[SSSoundPlayer sharedInstance] stopSearchingStatic];
    return [SSSoundStateNotLocked sharedInstance];
}

-(SSSoundState*) santaOnscreenNearlylocked {
    // No state change; nothing to do.
    return self;
}

-(SSSoundState*) santaOnscreenLocked {
    
    // Play a quick "lock" sound
    [[SSSoundPlayer sharedInstance] playClickOn];
    
    [[SSSoundPlayer sharedInstance] stopSearchingStatic];
    
    return [SSSoundStateLocked sharedInstance];
}

#pragma mark - Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static SSSoundStateAlmostLocked* sSharedInstance = nil;


+(SSSoundStateAlmostLocked*) sharedInstance
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
