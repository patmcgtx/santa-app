//
//  SSRelaxingSounds.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/17/12.
//
//

#import "SSRelaxingSounds.h"
#import "SSSoundPlayer.h"

@implementation SSRelaxingSounds

-(void) play {
    [[SSSoundPlayer sharedInstance] startRelaxing];
}


@end
