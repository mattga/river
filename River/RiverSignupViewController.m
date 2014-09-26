//
//  RiverSignupViewController.m
//  River
//
//  Created by Matthew Gardner on 9/7/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverSignupViewController.h"
#import "RiverAlertUtility.h"
#import "RiverAuthController.h"

@interface RiverSignupViewController ()

@end

@implementation RiverSignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)validateInput {
	
	if ([[self.displayNameField.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
		[RiverAlertUtility showErrorMessage:@"Please provide a display name."];
		return NO;
	}
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

- (IBAction)continuePressed:(id)sender {
	
	if ([self validateInput]) {
		[RiverAuthController authorizedRESTCall:kRiverWebApiUser
										 action:nil
										   verb:kRiverWebApiVerbPost
											_id:nil
									 withParams:@{@"Email":self.emailField.text, @"Username":self.displayNameField.text, @"Password":self.passwordField.text}
									   callback:^(NSDictionary *object, NSError *err) {
										   if (!err) {
											   User *user = [[User alloc] init];
											   [user readFromJSONObject:object];
											   
											   if (user.statusCode.intValue == kRiverStatusOK) {
												   [RiverAuthController sharedAuth].currentUser = user;
												   
												   if ([RiverAuthController sharedAuth].authDelegate) {
													   [[RiverAuthController sharedAuth].authDelegate userAuthorized:nil];
												   }
											   }
										   }
									   }];
	}
}

@end
