//
//  SSFlipsideViewController.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SSFlipsideViewController.h"
#import "RTSLog.h"
#import "RTSAppHelper.h"
#import "SSPromptUserLocationController.h"
#import "SSSavedAppState.h"

@interface SSFlipsideViewController ()

@property (nonatomic, strong) NSString* newsAppStoreLink;
@property (nonatomic, strong) NSString* appName;
@property (weak, nonatomic) IBOutlet UITextView *privacyPolicyLabel;

-(void) loadNewsContent;

@end

@implementation SSFlipsideViewController

@synthesize delegate = _delegate;
@synthesize distanceToSanta;
@synthesize newsAppStoreLink;
@synthesize appName;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated {
    
    // Reset this just to be sure
    self.shareActivityIndicator.hidden = YES;
    
    // Hide the share button if the necessary API is not there (iOS 6+)
    if (! NSClassFromString(@"UIActivityViewController")) {
        
        self.shareButton.hidden = YES;
        self.shareButton.enabled = NO;
        
        // Also re-center the help button to make the layout better
        CGRect screenBounds = [RTSAppHelper windowBoundsForLandscape:YES
                                                          forCocos2d:NO];
        self.helpButton.center = CGPointMake(screenBounds.size.width/2.0,
                                             self.helpButton.center.y);        
    }

    // Save app name for later too
    self.appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    
    // And other labeles...
    self.locationLabel.text = [[SSSavedAppState sharedInstance] placemarkLabel];
    
    // Localizations
    self.privacyPolicyLabel.text = NSLocalizedString(@"PRIVACY_POLICY_LABEL", nil);
}

-(void) viewDidAppear:(BOOL)animated {

    self.newsTextView.text = NSLocalizedString(@"RTS_NEWS_DEFAULT_TEXT", nil);
    self.newsAppStoreLink = NSLocalizedString(@"RTS_NEWS_DEFAULT_LINK", nil);
    
    [self performSelectorInBackground:@selector(loadNewsContent) withObject:nil];
}

- (void)viewDidUnload
{
    [self setShareButton:nil];
    self.distanceToSanta = nil;
    
    [self setNewsTextView:nil];
    [self setHelpButton:nil];
    [self setLocationLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)share:(id)sender {
    
    //self.shareActivityIndicator.hidden = NO; -- Does not work, so have to do this...
    [self.shareActivityIndicator performSelectorInBackground:@selector(setHidden:) withObject:NO];
    
    NSString* shareFormat = NSLocalizedString(@"SHARE_TEXT", nil);
    
    NSString* shareText = [NSString stringWithFormat:shareFormat,
                           self.distanceToSanta, self.appName,
                           NSLocalizedString(@"APP_HOME_URL", nil)];

    // I used to include an image, but it's best to just send the App Store
    // link.  That way twitter, etc. focuses on the App Store page instead
    // of the image.
    UIActivityViewController* activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:@[shareText]
                                            applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeSaveToCameraRoll ];
    
    [self presentViewController:activityVC animated:NO completion:^{
        self.shareActivityIndicator.hidden = YES;
    }];
}


- (IBAction)newsClicked:(id)sender {
    
    LOG_TMP_DEBUG(@"News clicked");
    
    if ( self.newsAppStoreLink ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newsAppStoreLink]];
    }
}

- (IBAction)help:(id)sender {
    
    LOG_TMP_DEBUG(@"Help clicked");
    
    if ( self.newsAppStoreLink ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"APP_HELP_URL", nil)]];
    }
}

- (IBAction)companyLink:(id)sender {
    
    LOG_TMP_DEBUG(@"Company link clicked");
    
    if ( self.newsAppStoreLink ) {
        [[UIApplication sharedApplication]
         openURL:[NSURL URLWithString:NSLocalizedString(@"RTS_HOME_URL", nil)]];
    }
    
}

- (IBAction)privacyPolicyLink:(id)sender {
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:NSLocalizedString(@"APP_PRIVACY_POLICY_URL", nil)]];
}

#pragma mark - Helpers

-(void) loadNewsContent {
    
    // Load news from my website.  Populates the newsText var with the content/body
    // of the localized URL.  Good thing I trust my own web site. ;-)
    // This method is run on a background thread to avoid holding up the main UI.
    
    NSError* error = nil;
    NSString* newsText = [NSString stringWithContentsOfURL:
                          [NSURL URLWithString:NSLocalizedString(@"RTS_NEWS_TEXT_SOURCE", nil)]
                                                  encoding:NSUTF8StringEncoding error:&error];
    if ( !error && newsText ) {
        // Once we have the data, have to update the UI on the main thread to avoid errors.
        // This will overwrite the default news text.
        [self.newsTextView performSelectorOnMainThread:@selector(setText:)
                                            withObject:newsText
                                         waitUntilDone:NO];
    }
    
    // Also load a localized URL for an App Store link from my website.
    NSError* error2 = nil;
    NSString* linkedURL = [NSString stringWithContentsOfURL:
                           [NSURL URLWithString:NSLocalizedString(@"RTS_NEWS_LINK_SOURCE", nil)]
                                                   encoding:NSUTF8StringEncoding error:&error2];
    if ( !error2 && linkedURL ) {
        self.newsAppStoreLink = linkedURL;
    }
}



#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
}

@end
