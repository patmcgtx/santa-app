//
//  RTSLandmark.h
//  OverThere
//
//  Created by Patrick McGonigle on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "RTSENUCoordinate.h"
#import "SSLandmarkType.h"

/**
 * This class represents a landmark to be displayed on an 
 * augmented-reality screen.  It provides properties to track
 * variations on the landmark's geographical location as well
 * as it's location on the screen.
 */
@interface RTSARLandmark : NSObject

// A unique identifier, to help track and associate the landmark
@property (nonatomic, assign) int landmarkId;

/** Localized *key* for the landmark's name as seen by the user */
@property (nonatomic, retain) NSString* nameKey;

/** The type of landmark, used to determine how the landmark looks */
@property (nonatomic, assign) SSLandmarkType landmarkType;

@property (nonatomic) RTSENUCoordinate enuCoordinates;

/** The landmark's standard geographical location */
@property (nonatomic) CLLocationCoordinate2D location;

/** The landmark's current spot on the screen */
@property (nonatomic) CGPoint screenPoint;

// TODO Add a distance-from-me attribute (to be converted to localized units)

-(id) initWithLandmarkId:(int)idVal 
         nameKey:(NSString*) nameVal 
            type:(SSLandmarkType) typeVal 
        location:(CLLocationCoordinate2D) locVal;

@end
