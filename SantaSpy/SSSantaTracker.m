//
//  SSSantaTracker.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/11/12.
//
//

#import "SSSantaTracker.h"
#import "SSWalkingSounds.h"
#import "RTSLog.h"
#import "SSWalkingSounds.h"
#import "SSWorkshopSounds.h"
#import "SSCelebrationShounds.h"
#import "SSChurchSounds.h"
#import "SSDeliveringPresentsSounds.h"
#import "SSEatingSounds.h"
#import "SSReindeersGallopingSounds.h"
#import "SSRelaxingSounds.h"
#import "SSSleepingSounds.h"
#import "SSTendingReindeerSounds.h"

@interface SSSantaTracker ()

@property (nonatomic, strong) NSCalendar* calendar;
@property (nonatomic) NSUInteger dayComponents;
@property (nonatomic) NSUInteger timeComponents;

/*
@property (nonatomic, strong) SSWalkingSounds* walkingSounds;
@property (nonatomic, strong) SSWorkshopSounds* workshopSounds;
@property (nonatomic, strong) SSCelebrationShounds* celebrationSounds;
@property (nonatomic, strong) SSChurchSounds* churchSounds;
@property (nonatomic, strong) SSDeliveringPresentsSounds* deliverySounds;
@property (nonatomic, strong) SSEatingSounds* eatingSounds;
@property (nonatomic, strong) SSReindeersGallopingSounds* gallopingSounds;
@property (nonatomic, strong) SSRelaxingSounds* relaxingSounds;
@property (nonatomic, strong) SSSleepingSounds* sleepingSounds;
@property (nonatomic, strong) SSTendingReindeerSounds* tendingReindeerSounds;
*/

-(NSDateComponents*) dateInfo;
-(NSDateComponents*) timeSinceMidnight;

@end

@implementation SSSantaTracker

/*
@synthesize walkingSounds = _walkingSounds;
*/

@synthesize calendar = _calendar;
@synthesize dayComponents = _dayComponents;
@synthesize timeComponents = _timeComponents;

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

-(SSSantaSounds*) currentSantaSounds {
    
    //
    // Well, this is a gigantic if/then/else clause.  Ugly.
    // On the other hand, this pretty mcuh accurately depicts what the
    // design wants.  Would be nice to break this into subclasses or methods
    // or do something elegant like a rules engine, but practiaclly speaking,
    // probably not worth it.
    //
    
    // This will fall back to sleeping if not set...
    SSSantaSounds* retval = nil;
    
    NSDateComponents* dateInfo = [self dateInfo];
    LOG_TMP_DEBUG(@"Today: %@", [dateInfo description]);

    NSDateComponents* sincePrevMidnight = [self timeSinceMidnight];
    LOG_TMP_DEBUG(@"Since midnight: %@", [sincePrevMidnight description]);
    
    if ( dateInfo.month == 12 && dateInfo.day == 24 ) {
        
        // Christmas eve
        
        // Prep reindeers 6 - 8 pm
        if ( sincePrevMidnight.hour > 18 && sincePrevMidnight.hour < 20) {
            LOG_TMP_DEBUG(@"Santa is prepping to delivery the presents");
            retval = [[SSTendingReindeerSounds alloc] init];
        }
        // Head out to delivery presents at 8 pm
        else if ( sincePrevMidnight.hour >= 20) {
            LOG_TMP_DEBUG(@"Santa is delivering presents!");
            retval = [[SSDeliveringPresentsSounds alloc] init];
        }
        
        // Otherwise, fall back to the normal scheudle
    }
    else if ( dateInfo.month == 12 && dateInfo.day == 25 ) {
        
        // Christmas
        
        // Deliver presents til 11 am
        if ( sincePrevMidnight.hour < 11) {
            LOG_TMP_DEBUG(@"Santa is delivering presents!");
            retval = [[SSDeliveringPresentsSounds alloc] init];
        }
        // Celebrate til 2 pm
        else if (sincePrevMidnight.hour < 14) {
            LOG_TMP_DEBUG(@"Santa is celebrating!");
            retval = [[SSCelebrationShounds alloc] init];
        }
        // Then head home to 3 pm
        else if (sincePrevMidnight.hour < 15) {
            LOG_TMP_DEBUG(@"Santa is going home!");
            retval = [[SSReindeersGallopingSounds alloc] init];
        }
        // Go to sleep real early!
        else {
            LOG_TMP_DEBUG(@"Santa is napping!");
            retval = [[SSSleepingSounds alloc] init];
        }
    }
    else if ( dateInfo.weekday == 1 ) {
        
        // Sundays
        
        // Church on Sunday mornings
        if ( sincePrevMidnight.hour < 8 ) {
            LOG_TMP_DEBUG(@"Santa is sleeping");
            retval = [[SSSleepingSounds alloc] init];
        }
        else if ( sincePrevMidnight.hour < 10 ) {
            LOG_TMP_DEBUG(@"Santa is at church");
            retval = [[SSChurchSounds alloc] init];
        }
        // Then some relaxing
        else if ( sincePrevMidnight.hour < 12 ) {
            LOG_TMP_DEBUG(@"Santa is relaxing");
            retval = [[SSRelaxingSounds alloc] init];
        }
        // Reindeer games til 3 pm
        else if ( sincePrevMidnight.hour < 15 ) {
            LOG_TMP_DEBUG(@"Santa is riding the reindeers");
            retval = [[SSReindeersGallopingSounds alloc] init];
        }
        // Tend the reindeer to 4 pm
        else if ( sincePrevMidnight.hour < 16 ) {
            LOG_TMP_DEBUG(@"Santa is riding the reindeers");
            retval = [[SSTendingReindeerSounds alloc] init];
        }
        // Go for a walk to 5 pm
        else if ( sincePrevMidnight.hour < 17 ) {
            LOG_TMP_DEBUG(@"Santa is going for a walk");
            retval = [[SSWalkingSounds alloc] init];
        }
    }
    
    // If not set by a special day above, fall back the normal schedule...
    
    if ( ! retval ) {
        // Before 7 am
        if ( sincePrevMidnight.hour < 7) {
            LOG_TMP_DEBUG(@"Santa is sleeping");
            retval = [[SSSleepingSounds alloc] init];
        }
        // 7am hour
        else if ( sincePrevMidnight.hour < 8 ) {
            
            if ( sincePrevMidnight.minute < 30 ) {
                LOG_TMP_DEBUG(@"Santa is eating breakfast");
                retval = [[SSEatingSounds alloc] init];
            }
            else {
                LOG_TMP_DEBUG(@"Santa is commuting to work");
                retval = [[SSReindeersGallopingSounds alloc] init];
            }
        }
        // 8am to noon
        else if ( sincePrevMidnight.hour < 12 ) {
            LOG_TMP_DEBUG(@"Santa is working the mornign shift");
            retval = [[SSWorkshopSounds alloc] init];
        }
        // noon hour
        else if ( sincePrevMidnight.hour < 13 ) {
            if ( sincePrevMidnight.minute < 15 ) {
                LOG_TMP_DEBUG(@"Santa is going to lunch");
                retval = [[SSWalkingSounds alloc] init];
            }
            else if ( sincePrevMidnight.minute < 45 ) {
                LOG_TMP_DEBUG(@"Santa is eating lunch");
                retval = [[SSEatingSounds alloc] init];
            }
            else {
                LOG_TMP_DEBUG(@"Santa is returning to work");
                retval = [[SSWalkingSounds alloc] init];
            }
        }
        // 1pm to 5pm
        else if ( sincePrevMidnight.hour < 17 ) {
            LOG_TMP_DEBUG(@"Santa is working the afternoon shift");
            retval = [[SSWorkshopSounds alloc] init];
        }
        // 5pm hour
        else if ( sincePrevMidnight.hour < 18 ) {
            if ( sincePrevMidnight.minute < 30 ) {
                LOG_TMP_DEBUG(@"Santa is commuting back home");
                retval = [[SSReindeersGallopingSounds alloc] init];
            }
            else {
                LOG_TMP_DEBUG(@"Santa is relaxing after work");
                retval = [[SSRelaxingSounds alloc] init];
            }
        }
        // 6pm hour
        else if ( sincePrevMidnight.hour < 19 ) {
            if ( sincePrevMidnight.minute < 30 ) {
                LOG_TMP_DEBUG(@"Santa is eating dinner");
                retval = [[SSEatingSounds alloc] init];
            }
            else {
                LOG_TMP_DEBUG(@"Santa is tending the reindeer after dinner");
                retval = [[SSTendingReindeerSounds alloc] init];
            }
        }
        // 7pm to 10pm
        else if ( sincePrevMidnight.hour < 22 ) {
            LOG_TMP_DEBUG(@"Santa is reading by the fireplace");
            retval = [[SSRelaxingSounds alloc] init];
        }
        // rest of day til midnight
        else {
            LOG_TMP_DEBUG(@"Santa is sleeping");
            retval = [[SSSleepingSounds alloc] init];
        }
        
        if ( ! retval ) {
            // Default to sleeping
            retval = [[SSSleepingSounds alloc] init];
        }
    }
    
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
    
    // Want to avoid being 100% predictable!
    // Use the day of month to vary the minute a bit. :-)
    // Can't use randomness; this has to be reproducable every
    // time it is callled.
    NSDateComponents* dateInfo = [self dateInfo];
    NSDateComponents* fuzziniess = [[NSDateComponents alloc] init];
    if ( dateInfo.day != 0 ) {
        [fuzziniess setMinute:(dateInfo.day / 3)];
    }
    else {
        [fuzziniess setMinute:(dateInfo.day)];
    }
    
    NSDate* fuzzyNow = [_calendar dateByAddingComponents:fuzziniess
                                                  toDate:now
                                                 options:0];
    
    /*
     * This is how you can set up a fake time for testing.
     * This is arguably easier than changing the time on your iPhone!
     NSDateComponents* fakeNowComp = [_calendar components:_dateHourMinute fromDate:[NSDate date]];
     [fakeNowComp setHour:23];
     [fakeNowComp setMinute:45];
     now = [_calendar dateFromComponents:fakeNowComp];
     */
    
    NSDateComponents* prevMidnightComp = [_calendar components:_timeComponents fromDate:fuzzyNow];
    [prevMidnightComp setMinute:0];
    [prevMidnightComp setHour:0];
    
    NSDate* previousMidnight = [_calendar dateFromComponents:prevMidnightComp];
    
    return [_calendar components:_timeComponents
                        fromDate:previousMidnight
                          toDate:now
                         options:0];
}


#pragma mark - Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static SSSantaTracker* sSharedInstance = nil;


+(SSSantaTracker*) sharedInstance
{
    if (sSharedInstance == nil) {
        sSharedInstance = [[super allocWithZone:NULL] init];
    }
    return sSharedInstance;
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
