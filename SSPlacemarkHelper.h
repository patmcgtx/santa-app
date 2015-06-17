//
//  SSPlacemarkHelper.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/29/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SSPlacemarkHelper : NSObject

+(NSString*) mainLabelForPlacemark:(CLPlacemark*) placemark;
+(NSString*) subLabelForPlacemark:(CLPlacemark*) placemark;
+(NSString*) summaryLabelForPlacemark:(CLPlacemark*) placemark;

@end
