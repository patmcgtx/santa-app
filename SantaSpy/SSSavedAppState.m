//
//  SSSavedAppState.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/21/13.
//
//

#import "SSSavedAppState.h"
#import "RTSAppHelper.h"
#import "RTSLog.h"
#import "SSErrorReporter.h"

#define kSSSavedAppStateKeyUserApproxLatitude @"userApproxLatitude"
#define kSSSavedAppStateKeyUserApproxLongitude @"userApproxLongitude"
#define kSSSavedAppStateKeyUserPlacemarkLabel @"userPlacemarkLabel"
#define kSSSavedAppStateKeyMainViewHasPromptedUserForLocation @"mainViewHasPromptedUserForLocation"

// Default locaiton is downtown Austin :-)
#define kSSSavedAppStateDefaultUserLatitude 30.267092
#define kSSSavedAppStateDefaultUserLongitude -97.74314

@implementation SSSavedAppState

static SSSavedAppState* _sharedInstance = nil;

- (id)init
{
    self = [super init];
    if (self) {
        // Nothng to do anymore :-)
    }
    return self;
}

-(CLLocationDegrees) userLatitude {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    CLLocationDegrees retval = [defaults doubleForKey:kSSSavedAppStateKeyUserApproxLatitude];
    if ( retval == 0.0 ) {
        retval = kSSSavedAppStateDefaultUserLatitude;
    }
    return retval;
}

-(void) setUserLatitude:(CLLocationDegrees)val {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:val forKey:kSSSavedAppStateKeyUserApproxLatitude];
    [defaults synchronize];
}

-(CLLocationDegrees) userLongitude {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    CLLocationDegrees retval = [defaults doubleForKey:kSSSavedAppStateKeyUserApproxLongitude];
    if ( retval == 0.0 ) {
        retval = kSSSavedAppStateDefaultUserLongitude;
    }
    return retval;
}

-(void) setUserLongitude:(CLLocationDegrees)val {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:val forKey:kSSSavedAppStateKeyUserApproxLongitude];
    [defaults synchronize];
}

-(NSString *)placemarkLabel {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* retval = [defaults stringForKey:kSSSavedAppStateKeyUserPlacemarkLabel];
    if ( ! retval ) {
        retval = NSLocalizedString(@"DEFAULT_LOC_NAME", nil);
    }
    return retval;
}

-(void) setPlacemarkLabel:(NSString *)val {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:val forKey:kSSSavedAppStateKeyUserPlacemarkLabel];
    [defaults synchronize];
}

-(BOOL) mainViewHasPromptedUserForLocation {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    BOOL retval = [defaults boolForKey:kSSSavedAppStateKeyMainViewHasPromptedUserForLocation];
    return retval;
}

-(void) setMainViewHasPromptedUserForLocation:(BOOL)val {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:val forKey:kSSSavedAppStateKeyMainViewHasPromptedUserForLocation];
    [defaults synchronize];
}


#pragma mark - Utilities

-(BOOL) hasUserSuppliedLocation {
    return (self.userLatitude != kSSSavedAppStateDefaultUserLatitude
            && self.userLongitude != kSSSavedAppStateDefaultUserLongitude);
}

#pragma mark - Singleton instance

+ (SSSavedAppState*) sharedInstance {
    
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{ _sharedInstance = [[self alloc] init]; });
    }
    
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
