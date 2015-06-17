//
//  SSNetworkAccessErrorController.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 10/6/13.
//
//

#import "SSNetworkAccessErrorController.h"

@interface SSNetworkAccessErrorController ()

@property (weak, nonatomic) IBOutlet UILabel *errorTitle;
@property (weak, nonatomic) IBOutlet UITextView *errorMessage;
@property (weak, nonatomic) IBOutlet UIButton *doneLabel; // This is actually a button!

@end

@implementation SSNetworkAccessErrorController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Localizations
    self.errorTitle.text = NSLocalizedString(@"NETWORK_ERROR_LABEL", nil);
    self.errorMessage.text = NSLocalizedString(@"NETWORK_ERROR_MESSAGE", nil);
    [self.doneLabel setTitle:NSLocalizedString(@"DONE_LABEL", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)doneButtonPushed:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
