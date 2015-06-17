//
//  OTUIApplication.m
//  OverThere
//
//  Created by Patrick McGonigle on 9/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SSErrorReporter.h"
#import "RTSLog.h"

@implementation SSErrorReporter

@synthesize frontEnd;

-(void) disableAppWithMessageKey:(NSString*) msgKey
                           error:(NSError*) error
                       debugInfo:(NSString *)debugInfo {
    
    // Log it 
    if ( debugInfo ) {
        LOG_USER_ERROR(@"%@ [%@]", NSLocalizedString(msgKey, @"???"), debugInfo);
    }
    else {
        LOG_USER_ERROR(NSLocalizedString(msgKey, @"???"));
    }

    if ( error ) {
        LOG_USER_ERROR(@"%@ [%@]", msgKey, [error localizedDescription]);
        LOG_USER_ERROR(@"%@ [%@]", msgKey, [error localizedRecoverySuggestion]);
    }
    
    // And send it on to the front end
    [self.frontEnd disableApplicaton:msgKey];
}


-(void) warnUserWithMessageKey:(NSString*) msgKey 
                         error:(NSError*) error
                     debugInfo:(NSString *)debugInfo {
    
    // Log it
    if ( debugInfo ) {
        LOG_USER_WARNING(@"%@ [%@]", NSLocalizedString(msgKey, @"???"), debugInfo);
    }
    else {
        LOG_USER_WARNING(NSLocalizedString(msgKey, @"???"));
    }
    
    if ( error ) {
        LOG_USER_WARNING(@"%@ [%@]", msgKey, [error localizedDescription]);
        LOG_USER_WARNING(@"%@ [%@]", msgKey, [error localizedRecoverySuggestion]);
        LOG_USER_WARNING(@"%@ [%@]", msgKey, [error localizedRecoveryOptions]);
        LOG_USER_WARNING(@"%@ [%@]", msgKey, [error localizedFailureReason]);
    }
}


#pragma mark Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static SSErrorReporter* sSharedErrorReporter = nil;


+(SSErrorReporter*) sharedReporter
{
    if (sSharedErrorReporter == nil) {
        sSharedErrorReporter = [[super allocWithZone:NULL] init];
    }
    return sSharedErrorReporter;
}


+(id) allocWithZone:(NSZone*) zone
{
    return [self sharedReporter];
}


-(id) copyWithZone:(NSZone*) zone
{
    return self;
}

@end
