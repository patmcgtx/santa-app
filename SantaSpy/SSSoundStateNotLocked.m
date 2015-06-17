//
//  SSSoundStateNotLocked.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/11/12.
//
//

#import "SSSoundStateLocked.h"
#import "SSSoundStateAlmostLocked.h"
#import "SSSoundStateNotLocked.h"
#import "SSSoundPlayer.h"

@implementation SSSoundStateNotLocked

-(void) play {
    //[[SSSoundPlayer sharedInstance] stopAllSounds];
}

-(SSSoundState*) santaNotLocked {
    return self;
}

-(SSSoundState*) santaOnscreenNearlylocked {
    return [SSSoundStateAlmostLocked sharedInstance];
}

-(SSSoundState*) santaOnscreenLocked {
    
    // Play a quick "lock" sound
    [[SSSoundPlayer sharedInstance] playClickOn];
    
    return [SSSoundStateLocked sharedInstance];
}


#pragma mark - Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static SSSoundStateNotLocked* sSharedInstance = nil;


+(SSSoundStateNotLocked*) sharedInstance
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
