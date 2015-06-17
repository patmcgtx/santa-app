//
//  SSDatabasePopulator.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/15/13.
//
//

#import "SSDatabasePopulator.h"
#import "SSDataAccess.h"
#import "SSAppStateDAO.h"

@interface SSDatabasePopulator ()

-(BOOL) isDbEmpty;

@end

@implementation SSDatabasePopulator

- (void) populateDbIfEmpty {
    
    if ( [self isDbEmpty] ) {
         // Just rely on default values
        [[[SSDataAccess sharedInstance] appStateDAO] createAppState];
    }
    
}

#pragma mark - Internal

-(BOOL) isDbEmpty {
    return [[[SSDataAccess sharedInstance] appStateDAO] hasAppState];
}

@end
