//
//  SSPromptUserLocationController.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 9/22/13.
//
//

#import <UIKit/UIKit.h>

@interface SSPromptUserLocationController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addressInputField;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *inputViewArea;
@property (weak, nonatomic) IBOutlet UILabel *locPromptLabel;

- (IBAction)cancelButtonPushed:(id)sender;
- (IBAction)infoButtonPushed:(id)sender;
- (IBAction)searcFieldEditingBegan:(id)sender;

@end
