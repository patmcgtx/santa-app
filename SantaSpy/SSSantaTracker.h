//
//  SSSantaTracker.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/11/12.
//
//

#import <Foundation/Foundation.h>
#import "SSSantaSounds.h"

/*
 * This class knows where Santa is and what he is doing
 * at any given time.
 *
 * It is singleton because Santa can only be in one place
 * and doing one thing at a time. ;-)
 */
@interface SSSantaTracker : NSObject

+(SSSantaTracker*) sharedInstance;

-(SSSantaSounds*) currentSantaSounds;

@end
