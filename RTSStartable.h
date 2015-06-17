//
//  OTPausable.h
//  OverThere
//
//  Created by Patrick McGonigle on 9/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Denotes an obect which can be started and stopped.
 */
@protocol RTSStartable <NSObject>

/**
 * Starts the objects operation
 */
- (void) start;

/**
 * Undoes -start, stopping the object's operation
 */
- (void) stop;

@end
