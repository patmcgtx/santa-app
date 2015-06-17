//
//  SSCommutingSounds.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/11/12.
//
//

#import "SSWalkingSounds.h"
#import "SSSoundPlayer.h"

@implementation SSWalkingSounds

-(void) play {
    [[SSSoundPlayer sharedInstance] startWalkingOutdoors];
}

@end
