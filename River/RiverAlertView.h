//
//  RiverAlertView.h
//  River
//
//  Created by Matthew Gardner on 5/26/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiverAlertView : UIView

@property (weak, nonatomic) IBOutlet UITextView *alertMessageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UITextField *inputField;

- (RiverAlertView*)initWithContents:(NSString *)nibName;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)okPressed:(id)sender;

@end
