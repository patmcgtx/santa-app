//
//  SSEatingSounds.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/17/12.
//
//

#import "SSEatingSounds.h"
#import "SSSoundPlayer.h"

@implementation SSEatingSounds

-(void) play {
    [[SSSoundPlayer sharedInstance] startEating];
}

@end
