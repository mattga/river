//
//  RiverSetupViewController.h
//  River
//
//  Created by Matthew Gardner on 3/6/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RIVER_LABEL_ORIGIN_FINAL_Y		20

@interface RiverSetupViewController : UIViewController <UITextFieldDelegate> {
	CGFloat keyboardHeight;
}

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UIImageView *usernameBGImage;
@property (weak, nonatomic) IBOutlet UIImageView *usernameTakenBGImage;
@property (weak, nonatomic) IBOutlet UILabel *riverLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *riverLabelTopConstraint;

- (IBAction)usernameButton:(id)sender;

@end
