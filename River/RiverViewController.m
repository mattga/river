//
//  RiverViewController.m
//  River
//
//  Created by Matthew Gardner on 4/27/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverViewController.h"
#import "RiverSPLoginViewController.h"

@interface RiverViewController ()

@end

@implementation RiverViewController

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
	
	if ([self isKindOfClass:[RiverSPLoginViewController class]])
		[[UITextField appearance] setTintColor:kRiverDarkGray];
	else
		[[UITextField appearance] setTintColor:kRiverLightBlue];
	
	if (self.usernameLabel != nil && self.roomLabel != nil) {
		self.usernameLabel.text = [RiverAuthController sharedAuth].currentUser.DisplayName;
		self.roomLabel.text = ([GlobalVars getVar].memberedRoom==nil ? @"-" : [NSString stringWithFormat:@"%@",[[GlobalVars getVar].memberedRoom roomName]]);
		if ([GlobalVars getVar].memberedRoom != nil) {
			[self updateFooter];
		}
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resignResponderAndRevealToggle {
	[self.view endEditing:YES];
}

- (IBAction)backPressed:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)updateFooter {
	self.userTokensLabel.text = [NSString stringWithFormat:@"%d", [[RiverAuthController sharedAuth] currentUser].Tokens];
}




@end
