//
//  SSWorkshopSounds.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/17/12.
//
//

#import "SSWorkshopSounds.h"
#import "SSSoundPlayer.h"

@implementation SSWorkshopSounds

-(void) play {
    [[SSSoundPlayer sharedInstance] startWorkshop];
}

@end
