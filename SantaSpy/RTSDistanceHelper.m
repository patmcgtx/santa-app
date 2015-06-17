//
//  RTSDistanceHelper.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/15/13.
//
//

#import "RTSDistanceHelper.h"

@implementation RTSDistanceHelper

+(NSString*) localizedDistanceLabelFromLocation:(CLLocation*) loc1 toLocation:(CLLocation*) loc2 {
    
    NSString* retval = nil;
    
    if ( loc1 && loc2 ) {
        
        CLLocationDistance distanceInMeters = [loc1 distanceFromLocation:loc2];
        CLLocationDistance distanceInKm =  distanceInMeters / 1000.0;
        CLLocationDistance distanceInMiles =  distanceInKm * 0.62;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString* distanceUnit = [prefs objectForKey:@"distanceUnit"];
        
        if ( ! distanceUnit ) {
            
            // No preference set yet; first time to run.
            // Default it based on the user's lcoale.
            NSLocale *locale = [NSLocale currentLocale];
            BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
            
            if ( isMetric ) {
                distanceUnit = @"km";
            }
            else {
                distanceUnit = @"miles";
            }
            
            // Save it in the prefs for next time
            [prefs setValue:distanceUnit forKey:@"distanceUnit"];
        }
        
        if ( [distanceUnit isEqualToString:@"km"] ) {
            retval = [NSString stringWithFormat:@"%.0f %@",
                      distanceInKm,
                      NSLocalizedString(@"KILOMETERS_SHORT", nil)];
        }
        else {
            retval = [NSString stringWithFormat:@"%.0f %@",
                      distanceInMiles,
                      NSLocalizedString(@"MILES_SHORT", nil)];
            
        }
        
    }
    
    return retval;
}

@end