//
//  RiverSignupViewController.h
//  River
//
//  Created by Matthew Gardner on 9/7/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiverViewController.h"

@interface RiverSignupViewController : RiverViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *displayNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)continuePressed:(id)sender;

@end
