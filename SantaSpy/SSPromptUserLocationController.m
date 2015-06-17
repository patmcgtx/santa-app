//
//  SSPromptUserLocationController.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/22/13.
//
//

#import "SSPromptUserLocationController.h"
#import <CoreLocation/CoreLocation.h>
#import "RTSLog.h"
#import "SSErrorReporter.h"
#import "RTSLocationNoSensor.h"
#import "SSPlacemarkHelper.h"

@interface SSPromptUserLocationController ()

@property (strong, nonatomic) CLGeocoder* geocoder;
@property (strong, nonatomic) NSArray* placeChoices;
@property (nonatomic) BOOL isWaitingForGeocodeResults;
@property (nonatomic) BOOL hasStartedEditing;
@property (nonatomic, strong) CLCircularRegion* regionForGeoLookup;
@property (nonatomic, strong) NSMutableArray* placeNamesToLookup;
@property (nonatomic) BOOL hasShownNetworkError;
@property (weak, nonatomic) IBOutlet UIButton *cancelB;

- (IBAction)locationEditingChanged:(UITextField *)sender;

@property (weak, nonatomic) IBOutlet UITextField *locationInputText;


-(void) startLookingUpPlaceName:(NSString*) placeName;
-(void) startLookingUpNextQueuedPlaceName;
-(void) hideKeyboard;
-(void) didStartGeocodeRequest;
-(void) didFinishGeocodeRequest;

@end

@implementation SSPromptUserLocationController

@synthesize hasStartedEditing = _hasStartedEditing;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _hasStartedEditing = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.geocoder = [[CLGeocoder alloc] init];
    self.isWaitingForGeocodeResults = NO;
    self.placeNamesToLookup = [NSMutableArray array];
    self.hasShownNetworkError = NO;
    
    self.inputViewArea.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blue-bg"]];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gray-bg"]];
    self.tableView.backgroundView = imageView;

    // To hide the keyboard 
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    self.addressInputField.delegate = self;
    
    // Get the person's country from user prefs (not GPS, etc.) as a hint for later location lookups.
    id countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    self.regionForGeoLookup = nil;
    // This runs asynchronously, so it won't delay the view loading
    [self.geocoder geocodeAddressString:countryCode
                               inRegion:self.regionForGeoLookup // Could possibly be nil, but it will stil work
                      completionHandler:^(NSArray *placemarks, NSError *error) {
                          
                          // This part happens later, when the query comes back from Apple, after the view is loaded.
                          if (! error) {
                              NSArray* countryPlaceMatches = [NSArray arrayWithArray:placemarks];
                              if ( countryPlaceMatches ) {
                                  CLPlacemark* countryPlacemark = [countryPlaceMatches firstObject];
                                  if ( countryPlacemark ) {
                                      // Get a circular region in the middle of the user's country (from prefs)
                                      // as a hint for later location lookups.
                                      self.regionForGeoLookup = [[CLCircularRegion alloc] initWithCenter:countryPlacemark.location.coordinate radius:100.0 identifier:@"myCountryRegion"];
                                  }
                              }
                          }
                      }];
}

-(void) viewWillAppear:(BOOL)animated
{
    // Localizations
    self.locPromptLabel.text = NSLocalizedString(@"LOCATION_PROMPT", nil);
    self.locationInputText.text = NSLocalizedString(@"CITY_STATE_ETC", nil);
    self.cancelB.titleLabel.text = NSLocalizedString(@"CANCEL_LABEL", nil);
    [self.cancelB setTitle:NSLocalizedString(@"CANCEL_LABEL", nil) forState:UIControlStateNormal];
    
    self.placeChoices = [NSArray array]; // empty list to start
    
    // Small tweak for US vs non-US location label.
    // I think this is easier than localizing the whole project for US vs. non-US.
    NSString* language = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    NSString* country = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    if ( [language isEqualToString:@"en"] && ![country isEqualToString:@"US"] ) {
        self.addressInputField.text = @"City, country, etc.";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCancelB:nil];
    [self setAddressInputField:nil];
    [self setInfoButton:nil];
    [self setActivityIndicator:nil];
    [self setInputViewArea:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.placeChoices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"a-location-row";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CLPlacemark* placemark = [self.placeChoices objectAtIndex:indexPath.row];
    
    // We seem to always get a country, and usually an admin area (state),
    // not not necessarily a city.
    
    cell.textLabel.text = [SSPlacemarkHelper mainLabelForPlacemark:placemark];
    cell.detailTextLabel.text = [SSPlacemarkHelper subLabelForPlacemark:placemark];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The job here is just to tell the non-sensor location handler
    // which locaiton was selected and exit.
    
    CLPlacemark* placemark = [self.placeChoices objectAtIndex:indexPath.row];
    
    RTSLocationNoSensor* locSensor = [RTSLocationNoSensor sharedInstance];
    [locSensor setNewLocation:placemark.location];
    [locSensor setNewLabelForPlacemark:placemark];

	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (IBAction)cancelButtonPushed:(id)sender {
    [self hideKeyboard];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)infoButtonPushed:(id)sender {
}

-(void) startLookingUpPlaceName:(NSString*) placeName {

    // This method queries Apple for a list of matching places and popluates
    // the table with all matches.
    
    // Also, Apple says to not send more than one request at a time.
    // This method is designed to queue up requests if one comes in while
    // another is already going.  This is better than ignoring requests if
    // busy, which causes confusing output.
    
    if ( placeName.length > 1 ) { // Need at least 2 chars to query
        
        [self.placeNamesToLookup addObject:placeName];
        [self startLookingUpNextQueuedPlaceName];
    }
}

-(void) startLookingUpNextQueuedPlaceName {
    
    NSString* nextPlaceNameToLookup = [self.placeNamesToLookup firstObject];
    
    if ( nextPlaceNameToLookup ) { // Any left to look up?
        
        if ( ! self.isWaitingForGeocodeResults ) {
            
            // If not currently looking up a location, then kick one off
            [self.placeNamesToLookup removeObject:nextPlaceNameToLookup];
            [self didStartGeocodeRequest];
            [self.geocoder geocodeAddressString:nextPlaceNameToLookup
                                       inRegion:self.regionForGeoLookup
                              completionHandler:^(NSArray *placemarks, NSError *error) {
                                  
                                  // This happens later, when the query comes back from Apple
                                  [self didFinishGeocodeRequest];
                                  
                                  if (error) {
                                      // This can happen if the user just enters a bad
                                      // location name, even a bad spelling.  Don't do anything
                                      // dire or permanent here!
                                      LOG_INTERNAL_ERROR(@"Error on geocode lookup for [%@]", nextPlaceNameToLookup);
                                      
                                      // But do show an error if they have no network access
                                      if ( !self.hasShownNetworkError &&
                                          [error.domain isEqualToString:@"kCLErrorDomain"] &&
                                          error.code == kCLErrorNetwork ) {
                                          self.hasShownNetworkError = YES;
                                          [self hideKeyboard];
                                          [self performSegueWithIdentifier:@"place-prompt-to-net-error"
                                                                    sender:self];
                                      }
                                      
                                      return;
                                  }
                                  
                                  // Save the places for the user to pick from
                                  // and repopulate the table with those choices.
                                  self.placeChoices = [NSArray arrayWithArray:placemarks];
                                  [self.tableView reloadData];
                                  
                                  // Kick off the next place look (if any)
                                  [self startLookingUpNextQueuedPlaceName];
                              }];
        }
    }
}

- (IBAction)searcFieldEditingBegan:(id)sender {
    if ( ! self.hasStartedEditing ) {
        self.addressInputField.text = @"";
        self.hasStartedEditing = YES;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self startLookingUpPlaceName:self.addressInputField.text];
    return NO;
}

#pragma mark - Internal helpers

-(void) didStartGeocodeRequest {
    self.isWaitingForGeocodeResults = YES;
    [self.activityIndicator startAnimating];
}

-(void) didFinishGeocodeRequest {
    self.isWaitingForGeocodeResults = NO;
    [self.activityIndicator stopAnimating];
}

- (void) hideKeyboard {
    [self.addressInputField resignFirstResponder];
}


- (IBAction)locationEditingChanged:(UITextField *)sender {
    [self startLookingUpPlaceName:self.addressInputField.text];
}
@end
