//
//  OTAppHelper.h
//  OverThere
//
//  Created by Patrick McGonigle on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTSAppHelper : NSObject

+(CGRect) windowBoundsForLandscape:(BOOL)forLandscape forCocos2d:(BOOL)forCocos2d;

+(UIWindow*) appWindow;

+ (NSURL *)applicationDocumentsDirectory;

@end
