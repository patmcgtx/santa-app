//
//  OTUIApplication.h
//  OverThere
//
//  Created by Patrick McGonigle on 9/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSErrorReporterFrontEnd.h"

@interface SSErrorReporter : NSObject

@property (nonatomic, weak) id<SSErrorReporterFrontEnd> frontEnd;

+(SSErrorReporter*) sharedReporter;

/**
 * Stops the app and prevents its further functioning, displaying
 * a message of explanation to the user.  After calling this method,
 * the user will have no choice but to simply exit the app.  
 *
 * This method should be used in cases where the app cannot function
 * at all, and the user needs to be notified that the app is disabled
 * and why.  For example, if the device does not have a camera for
 * a photography app.  See OTHERE-55.
 * 
 * msgKey is the key name of the string to load from a localized 
 * strings files.
 *
 * debugInfo provides optional, perhaps non-human-readable, debug
 * information that would ostensibly be reported back to me to
 * help identity specifics of the error.  Can be nil. One helpful
 * pattern is to simply send in a random string which I can find
 * in the code to see exactly what happened.
 */
-(void) disableAppWithMessageKey:(NSString*) msgKey
                           error:(NSError*) error
                       debugInfo:(NSString*) debugInfo;

/**
 * Warns the user if some feature-impacting event or condition,
 * but allows the app to continue functioning, probably in a 
 * limited fashion.  See OTHERE-55.
 * 
 * msgKey is the key name of the string to load from a localized 
 * strings files.
 *
 * debugInfo provides optional, perhaps non-human-readable, debug
 * information that would ostensibly be reported back to me to
 * help identity specifics of the error.  Can be nil.  One helpful
 * pattern is to simply send in a random string which I can find
 * in the code to see exactly what happened.
 */
-(void) warnUserWithMessageKey:(NSString*) msgKey
                         error:(NSError*) error
                     debugInfo:(NSString*) debugInfo;

@end
