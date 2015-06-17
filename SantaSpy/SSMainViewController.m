//
//  SSMainViewController.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "SSMainViewController.h"
#import "SSCameraPreview.h"
#import "RTSLog.h"
#import "SSAppDelegate.h"
#import "SSCocos2dEngine.h"
#import "SSCocosLandmarkLayer.h"
#import "RTSLocationProvider.h"
#import "RTSLocationNoSensor.h"
#import "RTSMotion.h"
#import "SSTimingSettings.h"
#import "SSLandmarkDAO.h"
#import "SSSoundDirector.h"
#import "SSErrorReporter.h"
#import "SSNotificationNames.h"
#import "SSLandmarkScreenMapper.h"
#import "RTSAppHelper.h"
#import "SSLandmarkWatcher.h"
#import "SSMainControllerState.h"
#import "SSMainControllerStateSleeping.h"
#import "SSMainControllerStateLocatingDevice.h"
#import "SSPromptUserLocationController.h"
#import "SSSavedAppState.h"

#define PARENT_GATE_MESSAGE_TIMEOUT_IN_SECS 15.0

@interface SSMainViewController ()

@property (nonatomic, retain) SSMainControllerState* state;
@property (nonatomic) BOOL locatingDeviceRightNow;
@property (nonatomic, strong) NSString* lastKnownErrorMessageKey;

@property (nonatomic) BOOL isShowingParentGateMessage;
@property (nonatomic, strong) NSTimer* parentGateMessageTimer;

@property (nonatomic, strong) SSCameraPreview* cameraView;
@property (nonatomic, strong) CCScene* cocos2dScene;
@property (nonatomic, strong) CCGLView* cocos2dView;
@property (nonatomic, strong) SSCocosLandmarkLayer* cocos2dLayer;
@property (nonatomic, strong) id<RTSLocationProvider> locationManager;
@property (nonatomic, strong) RTSARLandmark* santaLandmark;
@property (nonatomic, strong) SSSoundDirector* soundDirector;
@property (nonatomic) UIInterfaceOrientation lastKnownOrientation;
@property (nonatomic, strong) SSLandmarkScreenMapper* landmarkMapper;
@property (nonatomic, strong) SSLandmarkWatcher *landmarkWatcher;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *hudView;
@property (weak, nonatomic) IBOutlet UIImageView *directionIndicatorLeft;
@property (weak, nonatomic) IBOutlet UIImageView *directionIndicatorRight;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bullsEyeRectangle;
@property (weak, nonatomic) IBOutlet UIImageView *outerRectangle;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIImageView *lockedIndicatorBullseye;
@property (weak, nonatomic) IBOutlet UIImageView *lockedIndicatorOuter;
@property (weak, nonatomic) IBOutlet UITextView *parentGateText;
@property (weak, nonatomic) IBOutlet UIImageView *parentGateTextBg;
@property (weak, nonatomic) IBOutlet UIButton *parentGateTextCloseButton;

- (IBAction)didTouchInfoButton:(UIButton *)sender;
- (IBAction)closeParentGateText:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressRecognizer;
- (IBAction)didLongPress:(id)sender;


-(void) showParentGateMessage;
-(void) hideParentGateMessage;

-(void) openPlacePromptController;

@end

@implementation SSMainViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize cameraView = _cameraView;
@synthesize cocos2dView = _cocos2dView;
@synthesize cocos2dLayer = _cocos2dLayer;
@synthesize cocos2dScene = _cocos2dScene;
@synthesize locationManager = _locationManager;
@synthesize soundDirector = _soundDirector;
@synthesize activityIndicator = _activityIndicator;
@synthesize hudView = _hudBorderView;
@synthesize directionIndicatorLeft = _directionIndicatorLeft;
@synthesize directionIndicatorRight = _directionIndicatorRight;
@synthesize statusLabel = _statusLabel;
@synthesize bullsEyeRectangle;
@synthesize outerRectangle;
@synthesize infoButton = _infoButton;
@synthesize santaLandmark = _santaLandmark;
@synthesize lastKnownOrientation;
@synthesize landmarkMapper;
@synthesize landmarkWatcher;
@synthesize state;
@synthesize lastKnownErrorMessageKey;
@synthesize isShowingParentGateMessage = _isShowingParentGateMessage;
@synthesize parentGateMessageTimer;

#pragma mark - View controller lifecycle

-(void) viewDidLoad {
    
    [super viewDidLoad];

    self.locationManager = [RTSLocationNoSensor sharedInstance];
    [[RTSLocationNoSensor sharedInstance] setMainViewController:self]; // Ugly hack!
    
    self.landmarkMapper = nil; // Will init after location is ready
    self.locatingDeviceRightNow = NO;
    
    self.isShowingParentGateMessage = NO;
    self.parentGateMessageTimer = nil;
    
    self.lastKnownErrorMessageKey = nil;
    
    self.lastKnownOrientation = self.interfaceOrientation;

    // Start out in sleepig mode
    self.state = [SSMainControllerStateSleeping sharedInstance];
    [self.state execute:self];

    // Tell the error reporter to talk to me when it has an issue!
    SSErrorReporter* errReporter = [SSErrorReporter sharedReporter];
    errReporter.frontEnd = self;
    
    // Get the main window
    SSAppDelegate* delegate = (SSAppDelegate*) [[UIApplication sharedApplication] delegate];    
    UIWindow* window = [delegate window];
    
    // Add the camera subview
    self.cameraView = [[SSCameraPreview alloc] initWithFrame:window.bounds];
    [window insertSubview:self.cameraView atIndex:0];
    
    // Add the cocosd2d subview
    self.cocos2dView = [[SSCocos2dEngine sharedInstance] view];
    [self.view insertSubview:self.cocos2dView belowSubview:self.hudView];
    
    // Prevent the cocos2d layer from receiving any touch inputs at all.
    // We will save al interaction for the UIKit view below.
    [self.cocos2dView setUserInteractionEnabled:NO];
    
    self.cocos2dScene = [CCScene node];
    self.cocos2dLayer = [SSCocosLandmarkLayer node];
    
    [self.cocos2dScene addChild: self.cocos2dLayer];
    [[CCDirector sharedDirector] runWithScene: self.cocos2dScene];
    
    // Add the cocos2d view as a subview
    [self.view insertSubview:self.cocos2dView aboveSubview:self.view];
    
    // And start up the visible sensor event cycle
    [self.cocos2dLayer start];

    // Have to do this, or these componetns do not show up.
    // I think this is due to the zaniness of rearranging views
    // for cocos2d and the camera preview layer.
    self.hudView.layer.zPosition = 100.0;
    self.directionIndicatorLeft.layer.zPosition = 101.0;
    self.directionIndicatorRight.layer.zPosition = 101.0;
    self.activityIndicator.layer.zPosition = 101.0;
    self.statusLabel.layer.zPosition = 101.0;
    self.bullsEyeRectangle.layer.zPosition = 101.0;
    self.outerRectangle.layer.zPosition = 101.0;
    self.infoButton.layer.zPosition = 101.0;
    self.lockedIndicatorOuter.layer.zPosition = 101.0;
    self.lockedIndicatorBullseye.layer.zPosition = 101.0;
    self.parentGateText.layer.zPosition = 102.0;
    self.parentGateTextCloseButton.layer.zPosition = 102.0;
    self.parentGateTextBg.layer.zPosition = 101.0;
    
    // Load Santa
    SSLandmarkDAO* dao = [[SSLandmarkDAO alloc] init];
    self.santaLandmark = [dao getSanta];    
    
    // Get the sound player too
    self.soundDirector = [[SSSoundDirector alloc] init];
    
    //[self becomeFirstResponder]; // Re-enable to get shake events
    
    // Kick off motion sensor updates
    [[RTSMotion sharedMotion] start];

    // Gesture recognizers
    [self.view addGestureRecognizer:self.longPressRecognizer];
    
    // Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseApp)
                                                 name:SSNotificationAppWillBecomeInactive
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resumeApp)
                                                 name:SSNotificationAppDidBecomeActive
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifiedLocationDisaled)
                                                 name:SSNotificationLocationDisaled
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifiedSantaOffscreen:)
                                                 name:SSNotificationSantaWentOffscreen
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifiedSantaOffscreenLeft:)
                                                 name:SSNotificationSantaWentOffscreenLeft
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifiedSantaOffscreenRight:)
                                                 name:SSNotificationSantaWentOffscreenRight
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifiedSantaOnscreenUnlocked:)
                                                 name:SSNotificationSantaWentOnscreenUnlocked
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifiedSantaOnscreenNearlylocked:)
                                                 name:SSNotificationSantaWentOnscreenNearlyLocked
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifiedSantaOnscreenLocked:)
                                                 name:SSNotificationSantaWentOnscreenLocked
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifiedMapperLandmarkChanged:)
                                                 name:SSNotificationScreenMapperLandmarkChanged
                                               object:nil];
    
    // The location can take a while to come back.  Set up
    // and observer / notification pattern to handle the wait.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationReady)
                                                 name:SSNotificationGotDeviceLocation
                                               object:nil];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void) viewWillAppear:(BOOL)animated
{
    // Hide the status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    
    // Localizations
    self.parentGateText.text = NSLocalizedString(@"PARENT_GATE_INSTRUCTIONS", nil);
    // For some reason when we set the text in IOS 7, it reverts to plain style.
    // So now I have to reset the font style, etc.
    self.parentGateText.font = [UIFont fontWithName:@"Futura" size:18.0];
    self.parentGateText.textAlignment = NSTextAlignmentCenter;
    self.parentGateText.textColor = [UIColor colorWithRed:0.0588 green:0.2431 blue:0.5765 alpha:1.0];
    
    // Arrow animation
    self.directionIndicatorLeft.animationImages = @[
    [UIImage imageNamed:@"left"], [UIImage imageNamed:@"left_empty"]];
    self.directionIndicatorLeft.animationRepeatCount = 0;
    self.directionIndicatorLeft.animationDuration = 1.0;
    [self.directionIndicatorLeft startAnimating];

    self.directionIndicatorRight.animationImages = @[
    [UIImage imageNamed:@"right"], [UIImage imageNamed:@"right_empty"]];
    self.directionIndicatorRight.animationRepeatCount = 0;
    self.directionIndicatorRight.animationDuration = 1.0;
    [self.directionIndicatorRight startAnimating];

    self.isShowingParentGateMessage = NO;
    self.parentGateText.alpha = 0.0;
    self.parentGateTextBg.alpha = 0.0;
    self.parentGateTextCloseButton.alpha = 0.0;

    if ( self.parentGateMessageTimer ) {
        [self.parentGateMessageTimer invalidate];
        self.parentGateMessageTimer = nil;
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    // Do all this stuff  ~after~ the view has appeared to avoid
    // a slightly annoying delay when you launch the view.
    
    // Now move into locating mode
    self.state = [self.state locating:self];
    [state execute:self];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.state = [self.state hibernate:self];
    [state execute:self];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Clean up cocosd2
    [self.cocos2dLayer stopAllActions];
    [self.cocos2dLayer removeFromParentAndCleanup:YES];
    self.cocos2dLayer = nil;
    
    [self.cocos2dScene stopAllActions];
    [self.cocos2dScene removeFromParentAndCleanup:YES];
    self.cocos2dScene = nil;
    
    // Release the sensors
    [self.locationManager stop];
    self.locationManager = nil;
    
    [self setActivityIndicator:nil];
    [self setHudView:nil];
    [self setDirectionIndicatorLeft:nil];
    [self setDirectionIndicatorRight:nil];
    [self setStatusLabel:nil];
    [self setBullsEyeRectangle:nil];
    [self setInfoButton:nil];
    [self setSoundDirector:nil];
    [self setLockedIndicatorBullseye:nil];
    [self setLockedIndicatorOuter:nil];
    [self setOuterRectangle:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.    
    self.cameraView = nil;
    self.managedObjectContext = nil;    
    self.cocos2dLayer = nil;
    self.cocos2dView = nil;
    self.cocos2dScene = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
                                duration:(NSTimeInterval)duration {
    self.lastKnownOrientation = toInterfaceOrientation;
    [self.landmarkMapper changedInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark - Lifecycle handlers

-(void) didGoToSleep {
    [[NSNotificationCenter defaultCenter] postNotificationName:SSNotificationMainViewDidPause
                                                        object:nil];
}

-(void) willWakeUp {
    [[NSNotificationCenter defaultCenter] postNotificationName:SSNotificationMainViewWillResume
                                                        object:nil];
}

-(void) startFindingDeviceLocation {
    
    // Avoid going into this if we're already locating.
    // This can happen on initial startup, when we receive messages that both
    // the app is becoming active and the view is appearing.
    if ( ! self.locatingDeviceRightNow ) {
        
        self.locatingDeviceRightNow = YES;

        // The SSNotificationGotDeviceLocation notificaiton will come in
        // when the location is ready.
        
        // Clear out objects which are dependent on the location
        self.landmarkWatcher = nil;
        self.landmarkMapper = nil;
        self.landmarkMapper.delegate = nil;
        self.cocos2dLayer.landmarkMapper = nil;
        
        // Get a fresh location manager each time we need a fresh location.
        // Otherwise, we do not necessarily get location change evenst,
        // it -locationReady does not necessarily get called.
        //self.locationManager = [[RTSLocation alloc] initWithAccuracy:kCLLocationAccuracyThreeKilometers                                                 DistanceFilter:3000.0];
        
        // RTSLocation will send a notification to -locationReady when the loc is ready.
        [self.locationManager start];
    }
}

-(void) locationServiceDisabled {
    [self displayStatusLocalized:@"LOCATION_ERROR"];
}

#pragma mark - Visual modifiers

-(void) turnInnerLockIndicator:(BOOL) onOrOff {
    LOG_VISUALS(@"inner lock -> %@", onOrOff ? @"on" : @"off");
    self.lockedIndicatorBullseye.hidden = !onOrOff;
}

-(void) turnOuterLockIndicator:(BOOL) onOrOff {
    LOG_VISUALS(@"outer lock -> %@", onOrOff ? @"on" : @"off");
    self.lockedIndicatorOuter.hidden = !onOrOff;
}

-(void) turnLeftDirectionIndicator:(BOOL) onOrOff {
    LOG_VISUALS(@"left arrow -> %@", onOrOff ? @"on" : @"off");
    self.directionIndicatorLeft.hidden = !onOrOff;
}

-(void) turnRightDirectionIndicator:(BOOL) onOrOff {
    LOG_VISUALS(@"right arrow -> %@", onOrOff ? @"on" : @"off");
    self.directionIndicatorRight.hidden = !onOrOff;
}

-(void) turnActivityIndicator:(BOOL) onOrOff {
    LOG_VISUALS(@"activity indicator -> %@", onOrOff ? @"on" : @"off");
    self.activityIndicator.hidden = !onOrOff;
    if ( onOrOff ) {
        [self.activityIndicator startAnimating];
    }
    else {
        [self.activityIndicator stopAnimating];
    }
}

-(void) displayStatusLocalized:(NSString*) messageKey {
    LOG_VISUALS(@"status (localized) : %@", messageKey);
    self.statusLabel.text = NSLocalizedString(messageKey, @"updateStatusDisabled");
}

-(void) displayStatusLocalizedDistanceToSanta {
    
    LOG_VISUALS(@"status : distance to Santa");
    
    // TODO This Santa loc code is duplicate...
    CLLocation* santaLocation = [[CLLocation alloc]
                                 initWithLatitude:self.santaLandmark.location.latitude
                                 longitude:self.santaLandmark.location.longitude];
    
    self.statusLabel.text = [self.locationManager localizedDistanceLabelToLocation:santaLocation];
}

-(void) displayStatusLastKnownErrorLocalized {
    [self displayStatusLocalized:self.lastKnownErrorMessageKey];
}

-(void) clearStatus {
    LOG_VISUALS(@"status : clear:");
    self.statusLabel.text = @"";
}


#pragma mark - Pausable

- (void) pauseApp
{
    LOG_APP_LIFECYCLE(@"pauseApp");

    self.state = [self.state hibernate:self];
    [self.state execute:self];
}

- (void) resumeApp
{
    LOG_APP_LIFECYCLE(@"resumeApp");
    
    // Come back with Santa offscreen
    // In iOS 6 and earlier, this is already handled by -viewDidAppear.
    // But in iOS 7, it is not.
    
    self.state = [self.state locating:self];
    [state execute:self];
    
    [self showLocationDialogIfApplicable];
}

-(void) showLocationDialogIfApplicable {
    
    SSSavedAppState* appState = [SSSavedAppState sharedInstance];
    
    if ( !appState.mainViewHasPromptedUserForLocation && ![appState hasUserSuppliedLocation] ) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", nil)
                                                        message:NSLocalizedString(@"SET_LOCATION_TEXT", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"NO_THANKS", nil)
                                              otherButtonTitles:NSLocalizedString(@"OKAY", nil), nil];
        [alert show];
    }
    
}

-(void) notifiedLocationDisaled {
    
    LOG_APP_LIFECYCLE(@"notifiedLocationDisaled");
    
    // Come back with Santa offscreen
    self.state = [self.state locationDisabled:self];
    [self.state execute:self];    
}


#pragma mark - SSErrorReporterFrontEnd

-(void) disableApplicaton:(NSString*) messageKey {
    
    LOG_APP_LIFECYCLE(@"disabled : %@", messageKey);
    
    self.lastKnownErrorMessageKey = messageKey;
    
    //
    // Also remove state notifications; this will essentially gimp the app
    //
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SSNotificationSantaWentOffscreen
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SSNotificationSantaWentOffscreenLeft
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SSNotificationSantaWentOffscreenRight
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SSNotificationSantaWentOnscreenUnlocked
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SSNotificationSantaWentOnscreenNearlyLocked
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SSNotificationSantaWentOnscreenLocked
                                                  object:nil];
    
    self.activityIndicator.hidden = YES;
    
    self.state = [self.state disable:self];
    [self.state execute:self];
}


#pragma mark - Internal


/*
 This gets called when the location is finally available (up to several seconds
  after the view appears).
 */
-(void) locationReady
{
    LOG_TMP_DEBUG(@"locationReady");
    
    //
    // Set up the landmark mapper and watcher
    //
    self.landmarkWatcher = [[SSLandmarkWatcher alloc]
                            initWithScreenRect:[RTSAppHelper
                                                windowBoundsForLandscape:YES
                                                forCocos2d:YES]
                            nearlyLockedRect:self.outerRectangle.frame
                            lockedRect:self.bullsEyeRectangle.frame];
    
    SSLandmarkDAO* dao = [[SSLandmarkDAO alloc] init];
    self.santaLandmark = [dao getSanta];
    
    self.landmarkMapper = [[SSLandmarkScreenMapper alloc] initWithBounds:[RTSAppHelper
                                                                          windowBoundsForLandscape:YES
                                                                          forCocos2d:YES]
                                                          deviceLocation:[self.locationManager currentLocation]
                                                                landmark:self.santaLandmark];
    
    self.landmarkMapper.delegate = self.landmarkWatcher;

    // Also feed the mapp the current orientation; it can get confused on startup
    [self.landmarkMapper changedInterfaceOrientation:self.lastKnownOrientation];
    
    // The cocosd layer needs this since it schedules the regular updates
    self.cocos2dLayer.landmarkMapper = self.landmarkMapper;
    
    // Tell the location manager to relax now, until further notice.
    [self.locationManager stop];
    
    self.locatingDeviceRightNow = NO;
    
    // Now move to actively scanning mode, starting out with Santa offscreen
    self.state = [self.state santaOffscreen:self];
    [self.state execute:self];
}

-(void) showParentGateMessage {
    
    // Don't restart the timer if it's already going
    if ( ! self.isShowingParentGateMessage ) {
        
        // Make it so the parent can press the hidden buttons
        self.isShowingParentGateMessage = YES;

        [UIView animateWithDuration:0.5 animations:^{
            self.parentGateText.alpha = 1.0;
            self.parentGateTextBg.alpha = 1.0;
            self.parentGateTextCloseButton.alpha = 1.0;
        }];

        
        // Also start a timer to expire the offer
        if ( self.parentGateMessageTimer ) {
             // Just in case!
            [self.parentGateMessageTimer invalidate];
            self.parentGateMessageTimer = nil;
        }
        
        // Give it a few secs, then stop accepting input
        NSDate* parentGateMessageExpireTime = [NSDate dateWithTimeIntervalSinceNow:PARENT_GATE_MESSAGE_TIMEOUT_IN_SECS];
        self.parentGateMessageTimer = [[NSTimer alloc] initWithFireDate:parentGateMessageExpireTime
                                                        interval:0.0
                                                          target:self
                                                        selector:@selector(hideParentGateMessage)
                                                        userInfo:nil
                                                         repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.parentGateMessageTimer forMode:NSDefaultRunLoopMode];
    }
}

-(void) hideParentGateMessage {
    self.isShowingParentGateMessage = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.parentGateText.alpha = 0.0;
        self.parentGateTextBg.alpha = 0.0;
        self.parentGateTextCloseButton.alpha = 0.0;
    }];
}

-(void) openPlacePromptController {
    [self performSegueWithIdentifier:@"main-to-place-prompt" sender:self];
}


#pragma mark - Receiving state notifictions

-(void) notifiedSantaOffscreen:(NSNotification *)notification {

    self.state = [self.state santaOffscreen:self];
    [self.state execute:self];
}

-(void) notifiedSantaOffscreenLeft:(NSNotification *)notification {

    self.state = [self.state santaOffscreenLeft:self];
    [self.state execute:self];
}

-(void) notifiedSantaOffscreenRight:(NSNotification *)notification {
    
    self.state = [self.state santaOffscreenRight:self];
    [self.state execute:self];
}

-(void) notifiedSantaOnscreenUnlocked:(NSNotification *)notification {
    
    self.state = [self.state santaOnscreenNotlocked:self];
    [self.state execute:self];
}

-(void) notifiedSantaOnscreenNearlylocked:(NSNotification *)notification {
    
    self.state = [self.state santaOnscreenNearlylocked:self];
    [self.state execute:self];
}

-(void) notifiedSantaOnscreenLocked:(NSNotification *)notification {

    LOG_TRACE(@"Santa on screen - locked");
    
    self.state = [self.state santaOnscreenLocked:self];
    [self.state execute:self];
}

// We get this message after the mapper's landmark has already changed
-(void) notifiedMapperLandmarkChanged:(NSNotification*) notification {
    
    RTSARLandmark* landmark = (RTSARLandmark*) [[notification userInfo]
                                                valueForKey:SSNotificationKeyLandmark];
    
    // Update meself for later
    if ( landmark ) {
        self.santaLandmark = landmark;
    }
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(SSFlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        
        [[segue destinationViewController] setDelegate:self];
        
        // TODO Duplcating this lookup from above...
        CLLocation* santaLocation = [[CLLocation alloc]
                                     initWithLatitude:self.santaLandmark.location.latitude
                                     longitude:self.santaLandmark.location.longitude];
        [[segue destinationViewController] setDistanceToSanta:
         [self.locationManager localizedDistanceLabelToLocation:santaLocation]];
    }
}

#pragma mark - Actions

- (IBAction)didTouchInfoButton:(UIButton *)sender {
    if ( self.isShowingParentGateMessage ) {
        [self closeParentGateText:sender];
    }
    else {
        [self showParentGateMessage];
    }
}

- (IBAction)closeParentGateText:(UIButton *)sender {
    if ( self.isShowingParentGateMessage ) {
        [self hideParentGateMessage];
    }
}

- (IBAction)didLongPress:(id)sender {
    [self performSegueWithIdentifier:@"showAlternate" sender:self];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    SSSavedAppState* appState = [SSSavedAppState sharedInstance];
    appState.mainViewHasPromptedUserForLocation = YES;
    
    if ( buttonIndex == 0 ) { // Cancel
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"SET_LOCATION_LATER_TEXT", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OKAY", nil)
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ( buttonIndex == 1 ) { // Okay
        [self performSegueWithIdentifier:@"main-to-place-prompt" sender:self];
    }
    
}

@end
