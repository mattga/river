//
//  RiverViewController.h
//  River
//
//  Created by Matthew Gardner on 4/27/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "RiverAlertUtility.h"
#import "RiverAppDelegate.h"
#import "GlobalVars.h"

@interface RiverViewController : UIViewController {
    RiverAppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UIButton *revealBarButton;

// Footer labels
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTokensLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)backPressed:(id)sender;

- (void)updateFooter;

@end
