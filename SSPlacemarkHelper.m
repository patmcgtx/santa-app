//
//  SSPlacemarkHelper.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/29/13.
//
//

#import "SSPlacemarkHelper.h"

@implementation SSPlacemarkHelper

+(NSString*) mainLabelForPlacemark:(CLPlacemark*) placemark
{
    NSString* retval = @"";
    
    if ( placemark ) {
        if ( placemark.locality ) {
            retval = placemark.locality;
        }
    }
    
    return retval;
}

+(NSString*) subLabelForPlacemark:(CLPlacemark*) placemark
{
    NSString* retval = @"";
    
    if ( placemark ) {
        if ( placemark.administrativeArea ) {
            retval = [NSString stringWithFormat:@"%@, %@", placemark.administrativeArea, placemark.country];
        }
        else if ( placemark.country) {
            retval = placemark.country;
        }
    }
    
    return retval;
}

+(NSString*) summaryLabelForPlacemark:(CLPlacemark*) placemark
{
    NSString* retval = @"";
    
    if ( placemark ) {
        if ( placemark.locality ) {
            if ( placemark.administrativeArea ) {
                retval = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea];
            }
            else {
                retval = placemark.locality;
            }
        }
        else if ( placemark.administrativeArea ) {
            if ( placemark.country ) {
                retval = [NSString stringWithFormat:@"%@, %@", placemark.administrativeArea, placemark.country];
            }
            else {
                retval = placemark.administrativeArea;
            }
        }
        else if ( placemark.country ) {
            retval = placemark.country;
        }
    }
    
    return retval;    
}

@end
