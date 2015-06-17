//
//  SSSavedAppState.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/21/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SSSavedAppState : NSObject

+ (SSSavedAppState*) sharedInstance;

@property (nonatomic) CLLocationDegrees userLatitude;
@property (nonatomic) CLLocationDegrees userLongitude;
@property (nonatomic, retain) NSString * placemarkLabel;
@property (nonatomic) BOOL mainViewHasPromptedUserForLocation;

// Has the user supplied a location, or are we using the default
-(BOOL) hasUserSuppliedLocation;

@end
