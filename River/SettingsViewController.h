//
//  SettingsViewController.h
//  River
//
//  Created by Matthew Gardner on 5/25/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiverViewController.h"
#import "RiverAuthAccount.h"

@interface SettingsViewController : RiverViewController <UITextFieldDelegate, RiverAuthDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UIImageView *usernameBGImage;
@property (weak, nonatomic) IBOutlet UIImageView *usernameTakenBGImage;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)logoutPressed:(id)sender;
- (IBAction)loginPressed:(id)sender;

@end
