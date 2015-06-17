//
//  SSSoundState.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/11/12.
//
//

#import "SSSoundState.h"

@implementation SSSoundState

-(void) play {
    // No nothing by default
}

-(SSSoundState*) santaNotLocked {
    // No-op by default
    return self;
}

-(SSSoundState*) santaOnscreenNearlylocked {
    // No-op by default
    return self;
}

-(SSSoundState*) santaOnscreenLocked {
    // No-op by default
    return self;
}


@end
