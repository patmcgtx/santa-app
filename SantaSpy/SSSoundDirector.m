//
//  SSSoundDirector.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/10/12.
//
//

#import "SSSoundDirector.h"
#import "SSSoundPlayer.h"
#import "SSNotificationNames.h"
#import "SSSantaTracker.h"
#import "RTSLog.h"
#import "SSSoundState.h"
#import "SSSoundStateNotLocked.h"

@interface SSSoundDirector ()

@property (nonatomic, strong) SSSoundState* state;

@end

@implementation SSSoundDirector

@synthesize state = _state;

- (id)init
{
    self = [super init];
    if (self) {
        
        // Start out unlocked
        _state = [SSSoundStateNotLocked sharedInstance];
        
        //
        // Register for notifications of new Santa states
        //
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifiedSantaOffscreen:)
                                                     name:SSNotificationSantaWentOffscreen
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifiedSantaOffscreenLeft:)
                                                     name:SSNotificationSantaWentOffscreenLeft
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifiedSantaOffscreenRight:)
                                                     name:SSNotificationSantaWentOffscreenRight
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifiedSantaOnscreenUnlocked:)
                                                     name:SSNotificationSantaWentOnscreenUnlocked
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifiedSantaOnscreenNearlylocked:)
                                                     name:SSNotificationSantaWentOnscreenNearlyLocked
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifiedSantaOnscreenLocked:)
                                                     name:SSNotificationSantaWentOnscreenLocked
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifiedSantaPing:)
                                                     name:SSNotificationSantaOnscreenPing
                                                   object:nil];
    }
    return self;
}

#pragma mark - Receiving state notifictions

-(void) notifiedSantaPing:(NSNotification *)notification {
    
    [[SSSoundPlayer sharedInstance] playBlip];
}

-(void) notifiedSantaOffscreen:(NSNotification *)notification {
    self.state = [self.state santaNotLocked];
    [self.state play];
}

-(void) notifiedSantaOffscreenLeft:(NSNotification *)notification {
    self.state = [self.state santaNotLocked];
    [self.state play];
}

-(void) notifiedSantaOffscreenRight:(NSNotification *)notification {
    self.state = [self.state santaNotLocked];
    [self.state play];
}

-(void) notifiedSantaOnscreenUnlocked:(NSNotification *)notification {
    self.state = [self.state santaNotLocked];
    [self.state play];
}

-(void) notifiedSantaOnscreenNearlylocked:(NSNotification *)notification {
    self.state = [self.state santaOnscreenNearlylocked];
    [self.state play];
}

-(void) notifiedSantaOnscreenLocked:(NSNotification *)notification {
    self.state = [self.state santaOnscreenLocked];
    [self.state play];
}

@end
