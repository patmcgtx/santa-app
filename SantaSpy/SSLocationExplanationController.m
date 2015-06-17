//
//  SSLocationExplanationController.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/22/13.
//
//

#import "SSLocationExplanationController.h"

@interface SSLocationExplanationController ()

@property (weak, nonatomic) IBOutlet UITextView *mainTextContent;
@property (weak, nonatomic) IBOutlet UITextView *bigDoneButtonLabel;

@end

@implementation SSLocationExplanationController

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
    NSString* mainText = NSLocalizedString(@"LOCATION_EXPLANATION", nil);
    self.mainTextContent.text = mainText;
    
    NSString* privPolicyLabelText = NSLocalizedString(@"DONE_LABEL", nil);
    self.bigDoneButtonLabel.text = privPolicyLabelText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPushed:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)bigDoneButtonClicked:(id)sender {
    return [self doneButtonPushed:sender];
}

@end
