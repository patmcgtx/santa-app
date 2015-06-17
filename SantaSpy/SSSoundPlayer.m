//
//  SSStaticSoundPlayer.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 10/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SSSoundPlayer.h"
#import "SSErrorReporter.h"
#import "RTSLog.h"
#import "SSNotificationNames.h"

@interface SSSoundPlayer ()

-(AVAudioPlayer*) createAudioPlayerForFile:(NSString*) fileName
                                 extension:(NSString*) fileExtension;

/*
 * Starts a sound looping indefinitely.
 * Tracks the sound in the active list.
 */
-(void) playSound:(AVAudioPlayer*) soundPlayer atRandomSpot:(BOOL) randomize;

/*
 * Stops a sound from playing.
 * Leaves it in the active list.
 */
-(void) stopSound:(AVAudioPlayer*) soundPlayer;

/*
 * Sets a sound player at random time (in seconds) between
 * its start and the end.
 */
-(void) moveSoundToRandomSpot:(AVAudioPlayer*) soundPlayer;

@property (nonatomic, retain) NSMutableSet* activeSounds;

@property (nonatomic, retain) AVAudioPlayer *blipPlayer;
@property (nonatomic, retain) AVAudioPlayer *clickOnPlayer;
@property (nonatomic, retain) AVAudioPlayer *clickOffPlayer;
@property (nonatomic, retain) AVAudioPlayer *searchingStaticPlayer;
@property (nonatomic, retain) AVAudioPlayer *celebrationPlayer;
@property (nonatomic, retain) AVAudioPlayer *churchPlayer;
@property (nonatomic, retain) AVAudioPlayer *deliveringPresentsPlayer;
@property (nonatomic, retain) AVAudioPlayer *eatingPlayer;
@property (nonatomic, retain) AVAudioPlayer *interferencePlayer;
@property (nonatomic, retain) AVAudioPlayer *reindeersGallopingPlayer;
@property (nonatomic, retain) AVAudioPlayer *relaxingPlayer;
@property (nonatomic, retain) AVAudioPlayer *sleepingPlayer;
@property (nonatomic, retain) AVAudioPlayer *tendingReindeersPlayer;
@property (nonatomic, retain) AVAudioPlayer *walkingOutdoorsPlayer;
@property (nonatomic, retain) AVAudioPlayer *workshopPlayer;


@end


@implementation SSSoundPlayer

@synthesize activeSounds = _activeSounds;
@synthesize blipPlayer = _blipPlayer;
@synthesize searchingStaticPlayer = _searchingStaticPlayer;
@synthesize clickOnPlayer = _clickOnPlayer;
@synthesize clickOffPlayer = _clickOffPlayer;
@synthesize celebrationPlayer = _celebrationPlayer;
@synthesize churchPlayer = _churchPlayer;
@synthesize deliveringPresentsPlayer = _deliveringPresentsPlayer;
@synthesize eatingPlayer = _eatingPlayer;
@synthesize interferencePlayer = _interferencePlayer;
@synthesize reindeersGallopingPlayer = _reindeersGallopingPlayer;
@synthesize relaxingPlayer = _relaxingPlayer;
@synthesize sleepingPlayer = _sleepingPlayer;
@synthesize tendingReindeersPlayer = _tendingReindeersPlayer;;
@synthesize walkingOutdoorsPlayer = _walkingOutdoorsPlayer;
@synthesize workshopPlayer = _workshopPlayer;

- (id)init
{
    LOG_TRACE(@"SSSoundPlayer init");
    
    self = [super init];
    if (self) {
        
        _activeSounds = [NSMutableSet setWithCapacity:3]; // 3 is a guess at optimal capacity, but it can hold more as neeed.
        
        //
        // Audio session
        //
        NSError *error1 = nil;
        [[AVAudioSession sharedInstance] setActive: YES error: &error1];
        if ( error1 ) {
            [[SSErrorReporter sharedReporter] warnUserWithMessageKey:@"AUDIO_INIT_ERROR"
                                                               error:error1
                                                           debugInfo:@"sound player : init : failt to set active"];
        }
        
        NSError* error2 = nil;
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient
                                               error: &error2];
        if ( error2 ) {
            [[SSErrorReporter sharedReporter] warnUserWithMessageKey:@"AUDIO_INIT_ERROR"
                                                               error:error2
                                                           debugInfo:@"sound player : init : failed to set category"];
        }
        
        //
        // Init the sounds
        //
        
        // The baseline volume is about 0.5 (half).  Otherwise, it plays really loud!
        
        _blipPlayer = [self createAudioPlayerForFile:@"blip" extension:@"caf"];
        _blipPlayer.volume = 0.5;
        [_blipPlayer prepareToPlay];

        _clickOnPlayer = [self createAudioPlayerForFile:@"clickon" extension:@"caf"];
        _clickOnPlayer.volume = 0.2;
        [_clickOnPlayer prepareToPlay];
        
        _clickOffPlayer = [self createAudioPlayerForFile:@"clickoff" extension:@"caf"];
        _clickOffPlayer.volume = 0.2;
        [_clickOffPlayer prepareToPlay];
        
        _searchingStaticPlayer = [self createAudioPlayerForFile:@"searchingStatic" extension:@"caf"];
        _searchingStaticPlayer.volume = 0.5;
        _searchingStaticPlayer.numberOfLoops = -1;
        
        _celebrationPlayer = [self createAudioPlayerForFile:@"celebrating" extension:@"caf"];
        _celebrationPlayer.volume = 0.5;
        _celebrationPlayer.numberOfLoops = -1;
        
        _churchPlayer = [self createAudioPlayerForFile:@"church" extension:@"caf"];
        _churchPlayer.volume = 0.5;
        _churchPlayer.numberOfLoops = -1;
        
        _deliveringPresentsPlayer = [self createAudioPlayerForFile:@"delivering-presents" extension:@"caf"];
        _deliveringPresentsPlayer.volume = 0.5;
        _deliveringPresentsPlayer.numberOfLoops = -1;
        
        _eatingPlayer = [self createAudioPlayerForFile:@"eating" extension:@"caf"];
        _eatingPlayer.volume = 0.5;
        _eatingPlayer.numberOfLoops = -1;
        
        _interferencePlayer = [self createAudioPlayerForFile:@"interference" extension:@"caf"];
        _interferencePlayer.volume = 0.35;
        _interferencePlayer.numberOfLoops = -1;
        
        _reindeersGallopingPlayer = [self createAudioPlayerForFile:@"reindeers-galloping" extension:@"caf"];
        _reindeersGallopingPlayer.volume = 0.5;
        _reindeersGallopingPlayer.numberOfLoops = -1;
        
        _relaxingPlayer = [self createAudioPlayerForFile:@"relaxing" extension:@"caf"];
        _relaxingPlayer.volume = 0.5;
        _relaxingPlayer.numberOfLoops = -1;
        
        _sleepingPlayer = [self createAudioPlayerForFile:@"sleeping" extension:@"caf"];
        _sleepingPlayer.volume = 0.5;
        _sleepingPlayer.numberOfLoops = -1;
        
        _tendingReindeersPlayer = [self createAudioPlayerForFile:@"tending-reindeer" extension:@"caf"];
        _tendingReindeersPlayer.volume = 0.5;
        _tendingReindeersPlayer.numberOfLoops = -1;
        
        _walkingOutdoorsPlayer = [self createAudioPlayerForFile:@"walking-outdoors" extension:@"caf"];
        _walkingOutdoorsPlayer.volume = 0.5;
        _walkingOutdoorsPlayer.numberOfLoops = -1;
        
        _workshopPlayer = [self createAudioPlayerForFile:@"workshop" extension:@"caf"];
        _workshopPlayer.volume = 0.5;
        _workshopPlayer.numberOfLoops = -1;
        
        // Register for notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopAllSounds)
                                                     name:SSNotificationMainViewDidPause
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopAllSounds)
                                                     name:SSNotificationMainViewWillResume
                                                   object:nil];
    }
    return self;
}

#pragma mark - Global controls

// This doesn't just pause the sounds, it actually kills them
// and removes them from the active list.
-(void) stopAllSounds {
    
    LOG_APP_LIFECYCLE(@"stopAllSounds");
    
    for ( AVAudioPlayer* soundPlayer in self.activeSounds ) {
        [self stopSound:soundPlayer];
    }
    
    // We had to be sure not to remove the sounds one at a time
    // while iterating the active list.  That causes a core!
    // First pasue
    [self.activeSounds removeAllObjects];
}

# pragma mark - Long running, repeating sounds (with start/stop)

-(void) startSearchingStatic {
    [self playSound:self.searchingStaticPlayer atRandomSpot:YES];
}

-(void) stopSearchingStatic {
    [self stopSound:self.searchingStaticPlayer];
}


-(void) startCelebrating {
    [self playSound:self.celebrationPlayer atRandomSpot:YES];
}

-(void) stopCelebrating {
    [self stopSound:self.celebrationPlayer];
}


-(void) startChurch {
    [self playSound:self.churchPlayer atRandomSpot:YES];
}

-(void) stopChurch {
    [self stopSound:self.churchPlayer];
}


-(void) startDeliveringPresents {
    [self playSound:self.deliveringPresentsPlayer atRandomSpot:NO];
}

-(void) stopDeliveringPresents  {
    [self stopSound:self.deliveringPresentsPlayer];
}


-(void) startEating {
    [self playSound:self.eatingPlayer atRandomSpot:YES];
}

-(void) stopEating {
    [self stopSound:self.eatingPlayer];
}


-(void) startInterference  {
    [self playSound:self.interferencePlayer atRandomSpot:YES];
}

-(void) stopInterference  {
    [self stopSound:self.interferencePlayer];
}


-(void) startReindeersGalloping  {
    [self playSound:self.reindeersGallopingPlayer atRandomSpot:YES];
}

-(void) stopReindeersGalloping  {
    [self stopSound:self.reindeersGallopingPlayer];
}


-(void) startRelaxing {
    [self playSound:self.relaxingPlayer atRandomSpot:YES];
}

-(void) stopRelaxing  {
    [self stopSound:self.relaxingPlayer];
}


-(void) startSleeping  {
    [self playSound:self.sleepingPlayer atRandomSpot:YES];
}

-(void) stopSleeping  {
    [self stopSound:self.sleepingPlayer];
}


-(void) startTendingReindeer {
    [self playSound:self.tendingReindeersPlayer atRandomSpot:YES];
}

-(void) stopTendingReindeer {
    [self stopSound:self.tendingReindeersPlayer];
}


-(void) startWalkingOutdoors {
    [self playSound:self.walkingOutdoorsPlayer atRandomSpot:YES];
}

-(void) stopWalkingOutdoors  {
    [self stopSound:self.walkingOutdoorsPlayer];
}


-(void) startWorkshop  {
    [self playSound:self.workshopPlayer atRandomSpot:YES];
}

-(void) stopWorkshop  {
    [self stopSound:self.workshopPlayer];
}


#pragma mark - One-time, quick-playing sounds (no start/stop)

-(void) playBlip {
    [self.blipPlayer play];
}

-(void) playClickOn {
    [self.clickOnPlayer play];
}

-(void) playClickOff {
    [self.clickOffPlayer play];
}


#pragma mark - Internal helpers

-(void) moveSoundToRandomSpot:(AVAudioPlayer*) soundPlayer {
    // This is not a very advanced or truly random function, but it is supposed
    // to be quicker than arc4random() or arc4random_uniform().  Should be good
    // enough for me!
    float randTime = random() % (long) soundPlayer.duration;
    soundPlayer.currentTime = randTime;
}


-(AVAudioPlayer*) createAudioPlayerForFile:(NSString*) fileName
                                 extension:(NSString*) fileExtension {
    
    LOG_TRACE(@"createAudioPlayerForFile");
    
    NSString *path =
    [[NSBundle mainBundle] pathForResource: fileName
                                    ofType: fileExtension];    
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath: path];
    
    NSError* error = nil;
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL: url
                                                           error: &error];
    if ( error ) {
        [[SSErrorReporter sharedReporter] warnUserWithMessageKey:@"AUDIO_INIT_ERROR"
                                                           error:error
                                                       debugInfo:
         [NSString stringWithFormat:@"sound player : failed to create audio player for : %@", url]];
    }

    player.delegate = self;
    
    return player;
}

-(void) playSound:(AVAudioPlayer*) soundPlayer atRandomSpot:(BOOL) randomize {
    
    LOG_TRACE(@"beginSound");
    
    if ( ! soundPlayer.isPlaying ) {
        
        if ( randomize ) {
            [self moveSoundToRandomSpot:soundPlayer];
        }
        
        [soundPlayer play];
    }
    
    // Add to the currently playing list regardless, even if muted
    [self.activeSounds addObject:soundPlayer];
}

-(void) stopSound:(AVAudioPlayer*) soundPlayer {

    LOG_TRACE(@"endSound");

    // Don't care about mute state in this method, would
    // stop the sound regardless.
    
    if ( soundPlayer.isPlaying ) {
        [soundPlayer stop];
    }
    
    // Don't remove the sound from the active list.
    // If we do, it causes a core on -stopAllSounds!
    // That is why this was changed to 'pause'.
    // The sound is still around, just not actively playing.
}

#pragma mark - AVAudioPlayerDelegate

/*
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    LOG_TRACE(@"audioPlayerDidFinishPlaying : %@", [player description]);
}
 */

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [[SSErrorReporter sharedReporter] warnUserWithMessageKey:@"AUDIO_PLAY_ERROR"
                                                       error:error
                                                   debugInfo:
     [NSString stringWithFormat:@"sound player : audioPlayerDecodeErrorDidOccur"]];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    LOG_TRACE(@"audioPlayerBeginInterruption : %@", [player description]);
    [self stopSound:player];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {
    LOG_TRACE(@"audioPlayerEndInterruption : %@", [player description]);
    // Don't think it necesarily make sense to automatically restart any sounds
    // after taking a phone call, etc.
    //[self playSound:player atRandomSpot:YES];
}

#pragma mark Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static SSSoundPlayer* sSharedInstance = nil;


+(SSSoundPlayer*) sharedInstance
{
    if (sSharedInstance == nil) {
        sSharedInstance = [[super allocWithZone:NULL] init];
    }
    return sSharedInstance;
}


+(id) allocWithZone:(NSZone*) zone
{
    return [self sharedInstance];
}


-(id) copyWithZone:(NSZone*) zone
{
    return self;
}



@end
