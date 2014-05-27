//
//  RiverSetupViewController.m
//  River
//
//  Created by Matthew Gardner on 3/6/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverSetupViewController.h"
#import "GlobalVars.h"
#import "RiverAuthAccount.h"
#import "RiverLoadingUtility.h"

@interface RiverSetupViewController ()

@end

@implementation RiverSetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[_usernameLabel setAlpha:0.0f];
	[_usernameBGImage setAlpha:0.0f];

}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[UIView animateWithDuration:1.1
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 
						 _riverLabelTopConstraint.constant = RIVER_LABEL_ORIGIN_FINAL_Y;
						 
						 [_riverLabel setFrame:CGRectMake(_riverLabel.frame.origin.x,
														  RIVER_LABEL_ORIGIN_FINAL_Y,
														  _riverLabel.frame.size.width,
														  _riverLabel.frame.size.height)];
						 
						 _riverLabel.transform = CGAffineTransformMakeScale(1.358f, 1.358f);
						 
						 
					 } completion:^(BOOL finished) {
						 
						 [UIView animateWithDuration:1.0
										  animations:^{
											  [_usernameLabel setAlpha:1.0f];
											  [_usernameBGImage setAlpha:1.0f];
										  }];
						 
						 [_usernameField becomeFirstResponder];
						 
					 }];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)usernameButton:(id)sender {
	[self.usernameField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	[[RiverLoadingUtility sharedLoader] startLoading:self.view
										   withFrame:CGRectMake(0, 0, screenSize.width, screenSize.height - keyboardHeight)
									  withBackground:YES];
	
	[RiverAuthAccount authorizedRESTCall:kRiverRESTNewUser withParams:@{@"userId" : _usernameField.text} callback:^(NSData *response, NSError *err) {
		
		NSString *responseText = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		
		if([responseText isEqualToString:[NSString stringWithFormat:@"Success creating new user %@!", _usernameField.text]]) {
			[_usernameBGImage setHidden:NO];
			[_usernameTakenBGImage setHidden:YES];
			
			// Write settings to file
			[GlobalVars getVar].username = _usernameField.text;
			
			[RiverAuthAccount sharedAuth].currentUser = [[User alloc] initWithID:_usernameField.text];
			
			NSLog(@"Setting username to %@", [GlobalVars getVar].username);
			[[GlobalVars getVar].settingsDict setValue:[GlobalVars getVar].username forKey:@"username"];
			[[GlobalVars getVar].settingsDict writeToFile:[GlobalVars getVar].settingsPath atomically:YES];
			
			[self performSegueWithIdentifier:@"riverSegue" sender:nil];
			
		} else {
			[_usernameBGImage setHidden:YES];
			[_usernameTakenBGImage setHidden:NO];
		}
		
		[[RiverLoadingUtility sharedLoader] stopLoading];
	}];
	
	return YES;
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    keyboardHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
}

@end
