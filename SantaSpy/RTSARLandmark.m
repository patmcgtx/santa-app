//
//  RTSLandmark.m
//  OverThere
//
//  Created by Patrick McGonigle on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RTSARLandmark.h"
#import "RTSLog.h"

@implementation RTSARLandmark

@synthesize landmarkId = _landmarkId;
@synthesize landmarkType = _landmarkType;
@synthesize location = _location;
@synthesize nameKey = _nameKey;
@synthesize screenPoint = _screenPoint;
@synthesize enuCoordinates = _enuCoordinates;

#pragma mark Object lifecycle

-(id) initWithLandmarkId:(int)idVal 
                 nameKey:(NSString *)nameVal 
                    type:(SSLandmarkType)typeVal 
                location:(CLLocationCoordinate2D)locVal
{
    LOG_OBJ_LIFECYCLE(@"initWithLandmarkId");
    
    self = [super init];
    if (self) {
        self.landmarkId = idVal;
        self.nameKey = nameVal; // the property automatically retains
        self.landmarkType = typeVal;
        self.location = locVal;
        
        self.screenPoint = CGPointZero;
        
        RTSENUCoordinate enu = {0.0, 0.0, 0.0};
        self.enuCoordinates = enu;
    }
    return self;
}


- (NSString*) description;
{
    return [NSString stringWithFormat:@"RTSARLandmark [id=%i, name=%@, type=%i]", 
            [self landmarkId], [self nameKey], [self landmarkType]];
}


#pragma mark Main methods

@end
