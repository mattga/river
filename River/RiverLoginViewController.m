//
//  RiverLoginViewController.m
//  River
//
//  Created by Matthew Gardner on 9/7/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverLoginViewController.h"

@interface RiverLoginViewController ()

@end

@implementation RiverLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)validateInput {
	
	if ([[self.emailField.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
		[RiverAlertUtility showErrorMessage:@"Please provide your email."];
		return NO;
	}
	if ([[self.passwordField.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
		[RiverAlertUtility showErrorMessage:@"Please provide a password"];
		return NO;
	}
	
	NSString *emailRegex = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	if (![emailTest evaluateWithObject:self.emailField.text]) {
		[RiverAlertUtility showErrorMessage:@"Invalid email."];
		return NO;
	}
	
	return YES;
}

- (IBAction)loginPressed:(id)sender {
	if ([self validateInput]) {
		[RiverAuthController authorizedRESTCall:kRiverWebApiUser
										 action:kRiverWebApiActionAuthenticate
										   verb:kRiverWebApiVerbPost
											_id:@"0"
									 withParams:@{@"Email":self.emailField.text, @"Password":self.passwordField.text}
									   callback:^(NSDictionary *object, NSError *err) {
										   if (!err) {
											   User *user = [[User alloc] init];
											   [user readFromJSONObject:object];
											   
											   if (!err && user.statusCode.intValue == kRiverStatusOK) {
												   
												   [RiverAuthController sharedAuth].currentUser = user;
												   
												   UINavigationController *nvc = [[[[UIApplication sharedApplication].delegate.window rootViewController] childViewControllers] firstObject];
												   NSMutableArray *vcs = [[nvc viewControllers] mutableCopy];
												   [vcs removeLastObject];
												   [vcs removeLastObject];
												   [nvc setViewControllers:vcs animated:YES];
												   [vcs.firstObject tabBarController].tabBar.hidden = NO;
											   } else {
												   [RiverAlertUtility showErrorMessage:err.localizedDescription];
											   }
										   }
									   }];
	}
}

#pragma mark - Text field delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.passwordField) {
		[self loginPressed:nil];
	}
	
	return YES;
}

@end
