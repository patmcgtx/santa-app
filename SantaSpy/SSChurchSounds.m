//
//  SSChurchSounds.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/17/12.
//
//

#import "SSChurchSounds.h"
#import "SSSoundPlayer.h"

@implementation SSChurchSounds

-(void) play {
    [[SSSoundPlayer sharedInstance] startChurch];
}

@end
