//
//  OTAppHelper.m
//  OverThere
//
//  Created by Patrick McGonigle on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RTSAppHelper.h"
#import "cocos2d.h"

@implementation RTSAppHelper


+(UIWindow*) appWindow
{
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    return delegate.window;
}

+(CGRect) windowBoundsForLandscape:(BOOL)forLandscape forCocos2d:(BOOL)forCocos2d
{
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    CGRect retval = [[delegate window] bounds];
    
    // Get the screen's bounds and flip it if it's portrait
    if (forLandscape && (retval.size.height > retval.size.width)) {
        retval.size = CGSizeMake( retval.size.height, retval.size.width );
    }
    
    // Scale up or down for cocos2d as neeed
    if (forCocos2d) {
        CCDirector *director = [CCDirector sharedDirector];
        float contentScaleFactor = [director contentScaleFactor];
        
        if( contentScaleFactor != 1 ) {
            retval.size.width *= contentScaleFactor;
            retval.size.height *= contentScaleFactor;
        }
    }
    
    return retval;
}

/**
 Returns the URL to the application's Documents directory.
 */
+ (NSURL*)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
