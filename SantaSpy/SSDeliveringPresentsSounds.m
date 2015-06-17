//
//  SSDeliveringPresentsSounds.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/17/12.
//
//

#import "SSDeliveringPresentsSounds.h"
#import "SSSoundPlayer.h"

@implementation SSDeliveringPresentsSounds

-(void) play {
    [[SSSoundPlayer sharedInstance] startDeliveringPresents];
}

@end
