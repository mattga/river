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
	
    [super viewDidLoad];
	
	_usernameField.text = [RiverAuthAccount sharedAuth].username;
	
	if ([[SPSession sharedSession] connectionState] != SP_CONNECTION_STATE_LOGGED_IN) {
		_loginButton.hidden = NO;
		_logoutButton.hidden = YES;
	} else {
		_loginButton.hidden = YES;
		_logoutButton.hidden = NO;
	}
	
    // Register KVO on synchronizer background thread
    appDelegate = (RiverAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self addObserver:self forKeyPath:@"appDelegate.syncId" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"appDelegate.syncId"]) {
		[(RiverViewController*)self performSelectorOnMainThread:@selector(updateFooter) withObject:nil waitUntilDone:NO];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"appDelegate.syncId"];
}

- (IBAction)logoutPressed:(id)sender {
	[[SPSession sharedSession] logout:^{
		NSLog(@"SettingsVC::Logout() - Logged out of Spotify.");
		
		_loginButton.hidden = NO;
		_logoutButton.hidden = YES;
	}];
}

- (IBAction)loginPressed:(id)sender {
	UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"RiverStoryboard_iPhone" bundle:[NSBundle mainBundle]];
	RiverSPLoginViewController *login = [loginSB instantiateViewControllerWithIdentifier:@"SpotifyLogin"];
	[(RiverSessionDelegate*)[SPSession sharedSession].delegate setRiverDelegate:self];
	
	[self.navigationController pushViewController:login animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	[[RiverLoadingUtility sharedLoader] startLoading:self.view
										   withFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
	
	[RiverAuthAccount authorizedRESTCall:kRiverRESTUser
								  action:nil
									verb:kRiverPut
									 _id:[RiverAuthAccount sharedAuth].username
							  withParams:@{@"Username" : textField.text}
								callback:^(NSDictionary *user, NSError *err) {
									
									if(!err) {
										User *u = [[User alloc] init];
										[u readFromJSONObject:user];
										
										if(u.statusCode.intValue == kRiverStatusOK) {
											[_usernameBGImage setHidden:NO];
											[_usernameTakenBGImage setHidden:YES];
											
											// Write settings to file
											[RiverAuthAccount sharedAuth].username = _usernameField.text;
											
											[RiverAuthAccount sharedAuth].currentUser = [[User alloc] initWithName:_usernameField.text];
											
											NSLog(@"Setting username to %@", [RiverAuthAccount sharedAuth].username);
											[[GlobalVars getVar].settingsDict setValue:[RiverAuthAccount sharedAuth].username forKey:@"username"];
											[[GlobalVars getVar].settingsDict writeToFile:[GlobalVars getVar].settingsPath atomically:YES];
											
										} else if (u.statusCode.intValue == kRiverStatusAlreadyExists) {
											[_usernameBGImage setHidden:YES];
											[_usernameTakenBGImage setHidden:NO];
										}
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
