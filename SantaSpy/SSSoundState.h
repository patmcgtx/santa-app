//
//  SSSoundState.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/11/12.
//
//

#import <Foundation/Foundation.h>

/*
 * Abstract base class for a sound state
 * as used by the SoundDirector.
 */
@interface SSSoundState : NSObject

/*
 * This plays the appropriate sounds after we are ~in~ the state.
 */
-(void) play;

/*
 * These handle ~transitions~ between states.
 * The return value is always the new state.
 */
-(SSSoundState*) santaNotLocked;
-(SSSoundState*) santaOnscreenNearlylocked;
-(SSSoundState*) santaOnscreenLocked;

@end
