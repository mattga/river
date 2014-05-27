//
//  SettingsViewController.m
//  River
//
//  Created by Matthew Gardner on 5/25/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "SettingsViewController.h"
#import "RiverAuthAccount.h"
#import "RiverLoadingUtility.h"
#import "RiverSPLoginViewController.h"
#import "GlobalVars.h"
#import "CocoaLibSpotify.h"

@implementation SettingsViewController

- (void)viewDidLoad {
	_usernameField.text =[GlobalVars getVar].username;
	
	if ([[SPSession sharedSession] connectionState] != SP_CONNECTION_STATE_LOGGED_IN) {
		_loginButton.hidden = NO;
		_logoutButton.hidden = YES;
	} else {
		_loginButton.hidden = YES;
		_logoutButton.hidden = NO;
	}
	
    [super viewDidLoad];
}

- (IBAction)logoutPressed:(id)sender {
	[[SPSession sharedSession] logout:^{
		NSLog(@"SettingsVC::Logout() - Logged out of Spotify.");
		
		_loginButton.hidden = NO;
		_logoutButton.hidden = YES;
	}];
}

- (IBAction)loginPressed:(id)sender {
	UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"LoginStoryboard_iPhone" bundle:[NSBundle mainBundle]];
	RiverSPLoginViewController *login = [loginSB instantiateViewControllerWithIdentifier:@"SpotifyLogin"];
	[(RiverSessionDelegate*)[SPSession sharedSession].delegate setRiverDelegate:self];
	
	[self.navigationController pushViewController:login animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	[[RiverLoadingUtility sharedLoader] startLoading:self.view
										   withFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)
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
			
		} else {
			[_usernameBGImage setHidden:YES];
			[_usernameTakenBGImage setHidden:NO];
			
			_usernameField.text = [GlobalVars getVar].username;
		}
		
		[[RiverLoadingUtility sharedLoader] stopLoading];
	}];
	
	return YES;
}

#pragma mark - River Auth delegate

- (void)spotifyAuthorizedForUser:(User *)user {
	_loginButton.hidden = YES;
	_logoutButton.hidden = NO;
}

@end
