//
//  SSCelebrationShounds.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/17/12.
//
//

#import "SSCelebrationShounds.h"
#import "SSSoundPlayer.h"

@implementation SSCelebrationShounds

-(void) play {
    [[SSSoundPlayer sharedInstance] startCelebrating];
}

@end
