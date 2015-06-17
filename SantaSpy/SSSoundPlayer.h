//
//  SSStaticSoundPlayer.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 10/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/*
 * This class plays sounds.  It just follows orders and does not
 * really know anything about the sounds it plays or when to
 * play them.  It is basically a CD player.
 *
 * It is singleton because we should only have one set of sounds
 * playing at a time.
 */
@interface SSSoundPlayer : NSObject <AVAudioPlayerDelegate>

+(SSSoundPlayer*) sharedInstance;

/*
 * Kills all active sounds.
 * Clears the active list.
 */
-(void) stopAllSounds;

//
// Infinitely looping sounds
//
-(void) startSearchingStatic;
-(void) stopSearchingStatic;

-(void) startCelebrating;
-(void) stopCelebrating;

-(void) startChurch;
-(void) stopChurch;

-(void) startDeliveringPresents;
-(void) stopDeliveringPresents;

-(void) startEating;
-(void) stopEating;

-(void) startInterference;
-(void) stopInterference;

-(void) startReindeersGalloping;
-(void) stopReindeersGalloping;

-(void) startRelaxing;
-(void) stopRelaxing;

-(void) startSleeping;
-(void) stopSleeping;

-(void) startTendingReindeer;
-(void) stopTendingReindeer;

-(void) startWalkingOutdoors;
-(void) stopWalkingOutdoors;

-(void) startWorkshop;
-(void) stopWorkshop;

// 
// Single-play sounds
//
-(void) playBlip;
-(void) playClickOn;
-(void) playClickOff;

@end
