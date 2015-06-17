//
//  SSSoundDirector.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/10/12.
//
//

#import <Foundation/Foundation.h>

/*
 * This class controls which sounds are playing at what
 * time, and it also stops all sounds as needed.
 * After being instantiated, it works mostly off of
 * notifications sent by the SSLandmarkWatcher.
 */
@interface SSSoundDirector : NSObject

@end
