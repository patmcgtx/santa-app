//
//  SSLandmarkDAO.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SSLandmarkDAO.h"
#import "RTSLog.h"

@interface SSLandmarkDAO ()

-(NSDateComponents*) dateInfo;
-(NSDateComponents*) timeSinceMidnight;

@property (nonatomic) NSUInteger dayComponents;
@property (nonatomic) NSUInteger timeComponents;
@property (nonatomic, strong) NSCalendar* calendar;

@end

@implementation SSLandmarkDAO

@synthesize dayComponents = _dayComponents;
@synthesize timeComponents = _timeComponents;
@synthesize calendar = _calendar;

- (id)init
{
    self = [super init];
    if (self) {
        //
        // Set up the calendar for date calculations
        //
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [_calendar setTimeZone:[NSTimeZone systemTimeZone]];
        
        _timeComponents = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
        _dayComponents = NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    }
    return self;
}

-(RTSARLandmark*) getSanta
{
    CLLocationDegrees latitude = 0.0;
    CLLocationDegrees longitude = 0.0;
    
    CLLocationDegrees nPoleLatitude = 89.11293;
    CLLocationDegrees nPoleLongitude = -0.439453;
    
    // How many degress of lat and log to vary his location randomly.
    // A value of 10 is roughly the size of Texas.
    long randomVarianceInLatLong = 10.0; // Default: plus or minus 10
    
    // Santa's location is based on the date and time.
    // He stays in the N. Pole year-round but moves around the world on Xmas eve.
    
    // TODO This has to match up with SSSantaTracker.
    // Hmm, maybe I should combine these classes.
    // This really belong in SSSantaTracker!
    
    NSDateComponents* dateInfo = [self dateInfo];
    
    if ( dateInfo.month == 12 && dateInfo.day == 24 ) {
        
        NSDateComponents* sinceMidnight = [self timeSinceMidnight];
        
        // Head out to delivery presents after 8 pm.
        // Change location hourly.
        if ( sinceMidnight.hour < 20) {
            
            // Not left yet
            latitude = nPoleLatitude;
            longitude = nPoleLongitude;
            
            // When on the N. Pole, he does not move around
            randomVarianceInLatLong = 0.0;
        }
        else if ( sinceMidnight.hour < 21) {
            // Near Moscow
            latitude = 57.515823;
            longitude = 33.75;
        }
        else if ( sinceMidnight.hour < 22) {
            // England
            latitude = 51.631657;
            longitude = -1.142578;
        }
        else if ( sinceMidnight.hour < 23) {
            // Germany
            latitude = 51.165567;
            longitude = 10.239258;
        }
        else {
            // France
            latitude = 48.019324;
            longitude = 2.680664;
        }
    
    }
    else if ( dateInfo.month == 12 && dateInfo.day == 25 ) {
        
        NSDateComponents* sinceMidnight = [self timeSinceMidnight];
        
        if ( sinceMidnight.hour < 1) {
            // Spain
            latitude = 40.245992;
            longitude = -4.614258;
        }
        else if ( sinceMidnight.hour < 2) {
            // Cuba
            latitude = 22.958393;
            longitude = -82.001953;
        }
        else if ( sinceMidnight.hour < 3) {
            // Georgia
            latitude = 34.089061;
            longitude = -84.638672;
        }
        else if ( sinceMidnight.hour < 4) {
            // Pennsilvania
            latitude = 41.277806;
            longitude = -79.49707;
        }
        else if ( sinceMidnight.hour < 5) {
            // Perdinales!
            latitude = 30.331398;
            longitude = -98.258801;
        }
        else if ( sinceMidnight.hour < 6) {
            // Rocky Mountains
            latitude = 36.774092;
            longitude = -110.366211;
        }
        else if ( sinceMidnight.hour < 7) {
            // Mexico
            latitude = 20.179724;
            longitude = -100.327148;
        }
        else if ( sinceMidnight.hour < 8) {
            // Brazil
            latitude = -19.186678;
            longitude = -51.328125;
        }
        else if ( sinceMidnight.hour < 9) {
            // Australia
            latitude = -32.305706;
            longitude = 144.206543;
        }
        else if ( sinceMidnight.hour < 10) {
            // Nepal
            latitude = 28.574874;
            longitude = 82.792969;
        }
        else if ( sinceMidnight.hour < 11) {
            // N. Russia
            latitude = 62.062733;
            longitude = 61.699219;
        }
    }
    
    // Fall back to N. Pole type location if not Xmas
    if ( latitude == 0.0 && longitude == 0.0 ) {
        
        latitude = nPoleLatitude;
        longitude = nPoleLongitude;
        
        // When on the N. Pole, he does not move around
        randomVarianceInLatLong = 0.0;
    }
    
    LOG_TMP_DEBUG(@"Santa base loc: %f,%f", latitude, longitude);
    
    //
    // Now introduce some variance to keep him moving!
    //
    
    float randLatAdjustment = 0.0;
    float randLongAdjustment = 0.0;
    
    // * (h - l)  + l
    // * (10 - (-10)) + -10
    // * (10 + 10) - 10
    // 10
    
    if ( randomVarianceInLatLong > 0.0 ) {
        randLatAdjustment = random() % (long) ((randomVarianceInLatLong * 2.0) - randomVarianceInLatLong);
        randLongAdjustment = random() % (long) ((randomVarianceInLatLong * 2.0) - randomVarianceInLatLong);
    }
    
    CLLocationCoordinate2D santaLoc;
    santaLoc.latitude = latitude + randLatAdjustment;
    santaLoc.longitude = longitude + randLongAdjustment;

    LOG_TMP_DEBUG(@"Santa randomized loc: %f,%f", santaLoc.latitude, santaLoc.longitude);

    RTSARLandmark* retval = [[RTSARLandmark alloc] initWithLandmarkId:1
                                               nameKey:@"santa"
                                                  type:SSLandmarkTypeSanta
                                              location:santaLoc];
    return retval;
}

#pragma mark - Internal helpers

-(NSDateComponents*) dateInfo {
    
    NSDate *now = [NSDate date];
    
    return [_calendar components:_dayComponents fromDate:now];
}


/*
 * Returns hours and minutes since the previous midnight.
 */
-(NSDateComponents*) timeSinceMidnight {
    
    NSDate *now = [NSDate date];
    
    NSDateComponents* prevMidnightComp = [_calendar components:_timeComponents fromDate:now];
    [prevMidnightComp setMinute:0];
    [prevMidnightComp setHour:0];
    
    NSDate* previousMidnight = [_calendar dateFromComponents:prevMidnightComp];
    
    return [_calendar components:_timeComponents
                        fromDate:previousMidnight
                          toDate:now
                         options:0];
}


@end
