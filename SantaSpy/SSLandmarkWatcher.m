//
//  SSLandmarkWatcher.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/10/12.
//
//

#import "SSLandmarkWatcher.h"
#import "RTSLog.h"
#import "SSNotificationNames.h"

typedef enum {
    SSLandmarkWatcherStateOffscreen = 0,
    SSLandmarkWatcherStateOffscreenLeft = 1,
    SSLandmarkWatcherStateOffscreenLeftRight = 2,
    SSLandmarkWatcherStateOnscreenUnlocked = 3,
    SSLandmarkWatcherStateOnscreenNearlyLocked = 4,
    SSLandmarkWatcherStateOnscreenLocked = 5
} SSLandmarkWatcherState;

@interface SSLandmarkWatcher ()

@property (nonatomic) SSLandmarkWatcherState state;

// Left and right screen boundaries
@property (nonatomic) CGRect onScreenRect;
@property (nonatomic) CGRect nearlyLockedRect;
@property (nonatomic) CGRect lockedRect;

@property (nonatomic) CGFloat screenMinX;
@property (nonatomic) CGFloat screenMaxX;

@end

@implementation SSLandmarkWatcher

@synthesize state = _state;
@synthesize onScreenRect = _onScreenRect;
@synthesize nearlyLockedRect = _nearlyLockedRect;
@synthesize lockedRect = _lockedRect;
@synthesize screenMinX = _screenMinX;
@synthesize screenMaxX = _screenMaxX;

-(id) initWithScreenRect:(CGRect) onScreenRect
        nearlyLockedRect:(CGRect) nearlyLockedRect
              lockedRect:(CGRect) lockedRect {

    self = [super init];
    
    if (self) {
        
        _state = SSLandmarkWatcherStateOffscreen;
        
        _onScreenRect = onScreenRect;
        _nearlyLockedRect = nearlyLockedRect;
        _lockedRect = lockedRect;
        
        _screenMinX = onScreenRect.origin.x;    // i.e. 0
        _screenMaxX = onScreenRect.size.width;  // i.e. 480
    }
    return self;
}

#pragma mark - SSLandmarkChangeDelegate

-(void) landmarkWasUpdated:(RTSARLandmark*) landmarkVal {

    CGPoint newScreenPoint = landmarkVal.screenPoint;
    //LOG_INFO(@"DELEGATE: New point: %.2f/%.2f", newScreenPoint.x, newScreenPoint.y);
    
    // The basic idea is to compare the old state versus the new state.
    // (Only) if it changed, then notify observers of the new state.
    // Avoid sending out notifications if the state stays the same.
    
    SSLandmarkWatcherState oldState = self.state;

    if ( CGRectContainsPoint(self.lockedRect, newScreenPoint) ) {
        self.state = SSLandmarkWatcherStateOnscreenLocked;
        if ( self.state != oldState ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SSNotificationSantaWentOnscreenLocked
                                                                object:nil];
        }
    }
    else if ( CGRectContainsPoint(self.nearlyLockedRect, newScreenPoint) ) {
        self.state = SSLandmarkWatcherStateOnscreenNearlyLocked;
        if ( self.state != oldState ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SSNotificationSantaWentOnscreenNearlyLocked
                                                                object:nil];
        }
    }
    else if ( CGRectContainsPoint(self.onScreenRect, newScreenPoint) ) {
        self.state = SSLandmarkWatcherStateOnscreenUnlocked;
        if ( self.state != oldState ) {
             [[NSNotificationCenter defaultCenter] postNotificationName:SSNotificationSantaWentOnscreenUnlocked
                                                                object:nil];
        }
    }
    else if ( newScreenPoint.x < self.screenMinX ) {
        self.state = SSLandmarkWatcherStateOffscreenLeft;
        if ( self.state != oldState ) {
             [[NSNotificationCenter defaultCenter] postNotificationName:SSNotificationSantaWentOffscreenLeft
                                                                object:nil];
        }
    }
    else if ( newScreenPoint.x > self.screenMaxX ) {
        self.state = SSLandmarkWatcherStateOffscreenLeftRight;
        if ( self.state != oldState ) {
             [[NSNotificationCenter defaultCenter] postNotificationName:SSNotificationSantaWentOffscreenRight
                                                                object:nil];
        }
    }
    else {
        self.state = SSLandmarkWatcherStateOffscreen;
        if ( self.state != oldState ) {
             [[NSNotificationCenter defaultCenter] postNotificationName:SSNotificationSantaWentOffscreen
                                                                object:nil];
        }
    }
    
    // We also always send a notification if Santa is anywhere onscreen
    // to indicate a ping, or blink. This is even if the state did not change.
    if ( CGRectContainsPoint(self.onScreenRect, newScreenPoint) ) {
        
        // Send along the landmark too for more details.
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:landmarkVal forKey:SSNotificationKeyLandmark];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SSNotificationSantaOnscreenPing
                                                            object:nil
                                                          userInfo:userInfo];
    }
    
}


@end
