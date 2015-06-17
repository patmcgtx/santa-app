//
//  OTLandmarkHUDCocosMgr.m
//  OverThere
//
//  Created by Patrick McGonigle on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SSCocos2dEngine.h"
#import "RTSLog.h"
#import "RTSAppHelper.h"
#import "SSNotificationNames.h"

@implementation SSCocos2dEngine


#pragma mark Object lifecycle

- (id)init
{
    LOG_OBJ_LIFECYCLE(@"init");
    
    self = [super init];
    
    if (self) {
        
        // Set up the global the cocos2d director.
        // This is mostly taken from the standard cocos2d template 
        // app delegate and grafted on here.  Also made some changes
        // to support a transparent background.
        
        CCDirectorIOS* director = (CCDirectorIOS*) [CCDirector sharedDirector];        
        
        director.wantsFullScreenLayout = YES;
        [director setDelegate:self];
        [director setProjection:kCCDirectorProjection2D];
        
        //glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        glClearColor(0.0, 0.0, 0.0, 0.0);
        //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        if( ! [director enableRetinaDisplay:YES] ) {
            LOG_COCOS2D(@"Retina Display Not supported");
        }
        
#ifdef DEBUG_COCOS2D
        [director setDisplayStats:YES];
#else
        [director setDisplayStats:NO];
#endif
        
        [director setAnimationInterval:1.0/30];  // 30 FPS
        
        // Register for notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(purge)
                                                     name:SSNotificationMemoryWarning
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pause)
                                                     name:SSNotificationMainViewDidPause
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resume)
                                                     name:SSNotificationMainViewWillResume
                                                   object:nil];
    }
    
    return self;
}


#pragma mark Pausable

-(void) pause 
{
    LOG_APP_LIFECYCLE(@"pause");
    
    if ( ! [[CCDirector sharedDirector] isPaused] ) {
        [[CCDirector sharedDirector] pause];
    }
}


-(void) resume
{
    LOG_APP_LIFECYCLE(@"resume");
    
    if ( [[CCDirector sharedDirector] isPaused] ) {
        [[CCDirector sharedDirector] resume];
    }
}


#pragma mark Main

-(void) stop
{
    LOG_APP_LIFECYCLE(@"stop");
    [[CCDirector sharedDirector] stopAnimation];
    [[CCDirector sharedDirector] end];
    [self purge];
    
    // TODO Do these?
	//CCDirector *director = [CCDirector sharedDirector];	
	//[[director openGLView] removeFromSuperview];
}

-(void) purge
{
    LOG_APP_LIFECYCLE(@"purge");
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) significantTimeChange
{
    LOG_APP_LIFECYCLE(@"significantTimeChange");
    [[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (CCGLView*) view
{    
    if ( ! _glView ) {
        
        CCDirector *director = [CCDirector sharedDirector];
        
        CGRect size = [RTSAppHelper 
                       windowBoundsForLandscape:YES 
                       forCocos2d:YES];
        _glView = [CCGLView viewWithFrame:size pixelFormat:kEAGLColorFormatRGBA8 depthFormat:0];        
        
        // See KIDSCHED-90 - Transparency actually requires hacking cocos2d itself!
        _glView.opaque = NO;
        _glView.backgroundColor = [UIColor clearColor];
        
        CALayer* glLayer = [_glView layer];
        glLayer.opaque = NO;
        
        [director setView:_glView];
    }
    
    return _glView;
}

#pragma mark CCDirectorDelegate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark Singleton

//
// Singleton implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static SSCocos2dEngine* _sharedInstance = nil;


+(SSCocos2dEngine*) sharedInstance
{
    if (_sharedInstance == nil) {
        LOG_OBJ_LIFECYCLE(@"creating sharedInstance");
        _sharedInstance = [[super allocWithZone:NULL] init];
    }
    return _sharedInstance;
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

