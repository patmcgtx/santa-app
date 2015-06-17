//
//  KTBaseDAO.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SSBaseDAO.h"
#import "RTSLog.h"

@implementation SSBaseDAO

@synthesize managedObjectContext = _managedObjectContext;

- (id)initWithMOC:(NSManagedObjectContext*)moc
{
    self = [super init];
    if (self) {
        _managedObjectContext = moc;
    }
    return self;
    
}

- (void) commitChanges
{
    NSError *error = nil;
    
    if (self.managedObjectContext != nil)
    {
        if ([self.managedObjectContext hasChanges])
        {
            if (![self.managedObjectContext save:&error])
            {
                // TODO Notify user the save did not work!
                LOG_DATABASE(@"Error committing db changes %@, %@", error, [error userInfo]);
                abort();
            }
            else
            {
                LOG_DATABASE(@"Committed db changes.");
            }
        }
        else
        {
            LOG_DATABASE(@"No db changes to commit.");
        }
    }
    else
    {
        // TODO Notify user the save did not work!
        LOG_DATABASE(@"No managedObjectContext to commit!");
    }
}

- (void)deleteObject:(NSManagedObject *)object
{
    [self.managedObjectContext deleteObject:object];
}

@end
