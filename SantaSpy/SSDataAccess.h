//
//  KTDataAccess.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSAppStateDAO.h"

/**
 * Copied from Bedtime Balloons!
 */
@interface SSDataAccess : NSObject

@property (nonatomic, strong) SSAppStateDAO* appStateDAO;

@property (nonatomic, strong) NSURL* storeURL;
@property (readonly, strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel* managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;

+ (SSDataAccess*) sharedInstance;

- (void) commitChanges;

@end


