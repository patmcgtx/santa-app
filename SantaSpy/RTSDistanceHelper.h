//
//  RTSDistanceHelper.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/15/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RTSDistanceHelper : NSObject

+(NSString*) localizedDistanceLabelFromLocation:(CLLocation*) loc1
                                     toLocation:(CLLocation*) loc2;

@end
