//
//  SSLandmarkWatcher.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/10/12.
//
//

#import <Foundation/Foundation.h>
#import "SSLandmarkChangeDelegate.h"

/*
 * This class looks at changes to a landmark and fires off
 * notifications when its state changes in any important ways.
 */
@interface SSLandmarkWatcher : NSObject <SSLandmarkChangeDelegate>

-(id) initWithScreenRect:(CGRect) onScreenRect
        nearlyLockedRect:(CGRect) nearlyLockedRect
              lockedRect:(CGRect) lockedRect;

@end
