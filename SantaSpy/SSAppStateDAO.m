//
//  SSAppStateDAO.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/15/13.
//
//

#import "SSAppStateDAO.h"

@interface SSAppStateDAO ()

-(SSAppState*) appStateEntity;

@end

@implementation SSAppStateDAO

- (id)initWithMOC:(NSManagedObjectContext*)moc;
{
    self = [super initWithMOC:moc];
    if (self) {
        // Custom attrs here
    }
    return self;
}

#pragma mark - Properties

-(CLLocationCoordinate2D) userCoordinates {
   
    CLLocationCoordinate2D retval;
    SSAppState* appState = [self appStateEntity];
    
    retval.latitude = [appState.userLatitude doubleValue];
    retval.longitude = [appState.userLongitude doubleValue];
    
    return retval;
}

-(void) setUserCoordinates:(CLLocationCoordinate2D) coord {
    
    SSAppState* appState = [self appStateEntity];
    
    appState.userLatitude = [NSNumber numberWithDouble:coord.latitude];
    appState.userLatitude = [NSNumber numberWithDouble:coord.longitude];
    
    [self commitChanges];
}

#pragma mark - Entity operations

-(SSAppState*) createAppState
{
    SSAppState* retval = [NSEntityDescription
            insertNewObjectForEntityForName:@"AppState"
            inManagedObjectContext:self.managedObjectContext];
    
    retval.userLatitude = [NSNumber numberWithDouble:kSSAppStateUnsetLatitude];
    retval.userLongitude = [NSNumber numberWithDouble:kSSAppStateUnsetLongitude];
    
    return retval;
}


-(BOOL) hasAppState {
    
    SSAppState* appState = [self appStateEntity];
    return (! appState);
}

#pragma mark - Internal

-(SSAppState*) appStateEntity {
    
    SSAppState* retval = nil;
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"AppState"
                                              inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    if (array == nil)
    {
        // TODO deal with error...
    }
    else if ( [array count] > 0 ) {
        retval = [array objectAtIndex:0];
    }

    return retval;
}


@end
