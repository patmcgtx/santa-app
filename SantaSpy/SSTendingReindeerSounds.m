//
//  SSTendingReindeerSounds.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/17/12.
//
//

#import "SSTendingReindeerSounds.h"
#import "SSSoundPlayer.h"

@implementation SSTendingReindeerSounds

-(void) play {
    [[SSSoundPlayer sharedInstance] startTendingReindeer];
}

@end
