//
//  HelloWorldLayer.m
//  OverThere
//
//  Created by Patrick McGonigle on 9/1/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "SSCocosLandmarkLayer.h"
#import "RTSLog.h"
#import "SSErrorReporter.h"
#import "SSNotificationNames.h"
#import "SSLandmarkDAO.h" 

@interface SSCocosLandmarkLayer ()

@property (nonatomic, retain) CCSequence* pingSequence;
@property (nonatomic, strong) CCSprite* landmarkSprite;

@end

@implementation SSCocosLandmarkLayer

@synthesize pingSequence = _pingSequence;
@synthesize landmarkMapper;
@synthesize landmarkSprite = _landmarkSprite;

#pragma mark Object lifecycle

-(id) init
{
    LOG_OBJ_LIFECYCLE(@"init");
    
	if( (self=[super init]))
    {		
		self.isTouchEnabled = YES;
        
        //
        // Set up the sprite
        //
        
        _landmarkSprite = [CCSprite spriteWithFile:@"santa.png"];
        
        [self addChild:_landmarkSprite];
        _landmarkSprite.visible = YES;
        
        //
        // Set up the action.
        // Keep around to make Santa blink / ping.
        //
        
        CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:0.25];
        CCDelayTime* wait = [CCDelayTime actionWithDuration:0.25];
        CCFadeOut* fadeOut = [CCFadeOut actionWithDuration:0.25 ];
        _pingSequence = [CCSequence actions:fadeIn, wait, fadeOut, nil];        

        //
        // Register for notifications
        //
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notificationToPingSanta:)
                                                     name:SSNotificationSantaOnscreenPing
                                                   object:nil];
	}
	return self;
}

#pragma mark Scheduled methods

-(void) refresh {
    // The landmark mapper is only populated once we have the device location
    if ( self.landmarkMapper ) {
        [self.landmarkMapper refreshLandmark];
    }
}

-(void) updateLandmarkLocation {

    if ( self.landmarkMapper ) {
        
        CLLocationCoordinate2D currentSantaLoc = landmarkMapper.landmark.location;
        
        SSLandmarkDAO* dao = [[SSLandmarkDAO alloc] init];
        RTSARLandmark* newSanta = [dao getSanta];
        CLLocationCoordinate2D newSantaLoc = newSanta.location;
        
        // Just to be safe... Only bother the landmakr mapper if Santa's
        // location really did move.
        if ( newSantaLoc.latitude != currentSantaLoc.latitude
            || newSantaLoc.longitude != currentSantaLoc.longitude ) {
            landmarkMapper.landmark = newSanta;
        }
    }
}

#pragma  mark - Notifications


-(void) notificationToPingSanta:(NSNotification *)notification {
    
    RTSARLandmark* landmark = (RTSARLandmark*) [[notification userInfo]
                                                valueForKey:SSNotificationKeyLandmark];
    _landmarkSprite.visible = YES;
    _landmarkSprite.position = landmark.screenPoint;
    [_landmarkSprite runAction:_pingSequence];
}

#pragma mark - Startable

-(void) start
{    
    // !!! Remember to update the CC actoins above and
    // !!! _motionManager.deviceMotionUpdateInterval in RTSLocation.m to match!
    [self schedule:@selector(refresh) interval:1.0];
    
    // Note that this scheudle is automatically paused when cocos2d itself is paused,
    // which is handled by the app delegate & main controller (ie, not here)

    // Every so often (not very often), check if Santa moved.
    // Moving will basically only ever happen on Christmas Eve.
    [self schedule:@selector(updateLandmarkLocation) interval:300.0];
}

-(void) stop
{
    // Nothing to do, really.  This pauses when cocosc2d pauses.
    // TODO Unschedule?
}


@end
