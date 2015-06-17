//
//  SSAppState.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/15/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SSAppState : NSManagedObject

@property (nonatomic, retain) NSNumber * userLatitude;
@property (nonatomic, retain) NSNumber * userLongitude;

@end
