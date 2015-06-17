//
//  RTSMotion.h
//  OverThere
//
//  Created by Patrick McGonigle on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "RTSStartable.h"

@interface RTSMotion : NSObject <RTSStartable>

+(RTSMotion*) sharedMotion;

-(void) reset;

-(CMDeviceMotion*) currentMotion;

@end
