//
//  SSFlipsideViewController.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSFlipsideViewController;

@protocol SSFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(SSFlipsideViewController *)controller;
@end

@interface SSFlipsideViewController : UIViewController

@property (weak, nonatomic) id <SSFlipsideViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString* distanceToSanta;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UITextView *newsTextView;
@property (weak, nonatomic) IBOutlet UITextView *locationLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *shareActivityIndicator;

- (IBAction)done:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)newsClicked:(id)sender;
- (IBAction)help:(id)sender;
- (IBAction)companyLink:(id)sender;
- (IBAction)privacyPolicyLink:(id)sender;

@end
