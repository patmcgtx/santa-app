//
//  SSLandmarkDAO.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTSARLandmark.h"

/*
 * This class knows where Santa is, which depends entirely
 * the time and date.
 */
@interface SSLandmarkDAO : NSObject

-(RTSARLandmark*) getSanta;

@end
