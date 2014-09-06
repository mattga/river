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
#import "RiverAppDelegate.h"

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
	
	[[RiverLoadingUtility sharedLoader] startLoading:self.view
										   withFrame:CGRectNull];
	
	[RiverAuthAccount authorizedRESTCall:kRiverRESTUser
								  action:nil
									verb:kRiverPost
									 _id:nil
							  withParams:@{@"Username": textField.text}
								callback:^(NSDictionary *user, NSError *err) {
									
									if(!err) {
										User *u = [[User alloc] init];
										[u readFromJSONObject:user];
										
										if(u.statusCode.intValue == kRiverStatusOK) {
											[_usernameBGImage setHidden:NO];
											[_usernameTakenBGImage setHidden:YES];
											
											// Write settings to file
											[RiverAuthAccount sharedAuth].currentUser = [[User alloc] initWithName:_usernameField.text];
											[RiverAuthAccount sharedAuth].username = _usernameField.text;
											
											NSLog(@"Setting username to %@", [RiverAuthAccount sharedAuth].username);
											[[GlobalVars getVar].settingsDict setValue:[RiverAuthAccount sharedAuth].username forKey:@"username"];
											[[GlobalVars getVar].settingsDict writeToFile:[GlobalVars getVar].settingsPath atomically:YES];
											
											[self performSegueWithIdentifier:@"riverSegue" sender:nil];
											
										} else if (u.statusCode.intValue == kRiverStatusAlreadyExists) {
											[_usernameBGImage setHidden:YES];
											[_usernameTakenBGImage setHidden:NO];
										}
									}
									
									[[RiverLoadingUtility sharedLoader] stopLoading];
								}];
	
	return YES;
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    keyboardHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"riverSegue"]) {
		((RiverAppDelegate*)[[UIApplication sharedApplication] delegate]).window.rootViewController = segue.destinationViewController;
	}
}


@end
