//
//  SSAppStateDAO.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/15/13.
//
//

#import "SSBaseDAO.h"
#import "SSAppState.h"
#import <CoreLocation/CoreLocation.h>

static const double kSSAppStateUnsetLatitude = 0.0;
static const double kSSAppStateUnsetLongitude = 0.0;

@interface SSAppStateDAO : SSBaseDAO

- (id)initWithMOC:(NSManagedObjectContext*)moc;

-(BOOL) hasAppState;
-(SSAppState*) createAppState;

// Read/write coord property, saves to db on set
@property (nonatomic) CLLocationCoordinate2D userCoordinates;

@end
