//
//  SSMainControllerStateDisabled.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/12/12.
//
//

#import "SSMainControllerStateDisabled.h"
#import "RTSLog.h"

@implementation SSMainControllerStateDisabled

-(void) execute:(SSMainViewController*) controller {

    LOG_STATE(@"disabled execute");
    
    [controller displayStatusLastKnownErrorLocalized];
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

static SSMainControllerStateDisabled* sSharedInstancex = nil;


+(SSMainControllerStateDisabled*) sharedInstance
{
    if (sSharedInstancex == nil) {
        sSharedInstancex = [[super allocWithZone:NULL] init];
    }
    return sSharedInstancex;
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
