//
//  SSMainControllerStateBase.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/12/12.
//
//

#import <Foundation/Foundation.h>
#import "SSMainViewController.h"

/*
 * Abstract base class for all main controller states.
 */
@interface SSMainControllerState : NSObject

/*
 * This is what a state does once it just enters its state.
 * It can assume all other competing states have been wiped,
 * the decks have been cleared, and this state has full run 
 * of the place.  So this method assumes other state's artifacts
 * are now gone, and it is time to ADD my own stuff.
 *
 * Basically, this is where a state establishes itself on
 * a blank canvas.
 */
-(void) execute:(SSMainViewController*) controller;

//
// These handle ~transitions~ between states.
// The return value is always the new state.
//
// The job of these methods is for the state to ~undo~ itself
// (undo its visuals, etc.) and pick the next state.  So it
// is erasing itself from the canvas.
//

/*
 * Santa events
 */
-(SSMainControllerState*) santaOffscreen:(SSMainViewController*) controller;
-(SSMainControllerState*) santaOffscreenLeft:(SSMainViewController*) controller;
-(SSMainControllerState*) santaOffscreenRight:(SSMainViewController*) controller;

-(SSMainControllerState*) santaOnscreenNotlocked:(SSMainViewController*) controller;
-(SSMainControllerState*) santaOnscreenNearlylocked:(SSMainViewController*) controller;
-(SSMainControllerState*) santaOnscreenLocked:(SSMainViewController*) controller;

/*
 * The controller is hiding for a while, ie going to the background or another controller.
 */
-(SSMainControllerState*) hibernate:(SSMainViewController*) controller;

/*
 * The app is finding the device's location
 */
-(SSMainControllerState*) locating:(SSMainViewController*) controller;

/*
 * The app is has been denied the device's location
 */
-(SSMainControllerState*) locationDisabled:(SSMainViewController*) controller;

/*
 * The app is being permanently disabled, ie due to a hardware incompatibility
 */
-(SSMainControllerState*) disable:(SSMainViewController*) controller;

@end
