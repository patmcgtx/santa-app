//
//  SSReindeersGallopingSounds.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/17/12.
//
//

#import "SSReindeersGallopingSounds.h"
#import "SSSoundPlayer.h"

@implementation SSReindeersGallopingSounds

-(void) play {
    [[SSSoundPlayer sharedInstance] startReindeersGalloping];
}

@end
