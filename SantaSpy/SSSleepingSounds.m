//
//  SSSleepingSounds.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/17/12.
//
//

#import "SSSleepingSounds.h"
#import "SSSoundPlayer.h"

@implementation SSSleepingSounds

-(void) play {
    [[SSSoundPlayer sharedInstance] startSleeping];
}

@end
