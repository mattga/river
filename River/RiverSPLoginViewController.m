//
//  RiverSPLoginViewController.m
//  River
//
//  Created by Matthew Gardner on 5/15/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//
/*
 Copyright (c) 2011, Spotify AB
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of Spotify AB nor the names of its contributors may
 be used to endorse or promote products derived from this software
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL SPOTIFY AB BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "RiverSPLoginViewController.h"
#import "RiverLoadingUtility.h"

@interface RiverSPLoginViewController ()

@end

@implementation RiverSPLoginViewController
@synthesize scrollView;

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
    // Do any additional setup after loading the view.
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponders)];
	[self.view addGestureRecognizer:tapGesture];
	
	session = [SPSession sharedSession];
	sessionDelegate = session.delegate;
	
	self.usernameField.delegate = self;
	self.passwordField.delegate = self;
	
	scrollView.contentSize = CGSizeMake(320.0f, 600.0f);
}

- (void)viewDidAppear:(BOOL)animated {
	
    keyboardIsShown = NO;
	[self registerForKeyboardNotifications];
	
	[super viewDidAppear:animated];
}

- (void)resignFirstResponders {
	[self.usernameField resignFirstResponder];
	[self.passwordField resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.passwordField.text = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
	
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
	
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
	CGPoint origin = [self.passwordField.superview convertPoint:self.passwordField.frame.origin toView:self.view];
	
    if (!CGRectContainsPoint(aRect, origin) ) {
		[scrollView setContentOffset:CGPointMake(0.0, origin.y-kbSize.height) animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
	
	[UIView animateWithDuration:.4 animations:^{
		scrollView.contentInset = contentInsets;
		scrollView.scrollIndicatorInsets = contentInsets;
	}];
}

- (IBAction)loginPressed:(id)sender {
	if (self.usernameField.text.length == 0 || self.passwordField.text.length == 0) {
		[RiverAlertUtility showOKAlertWithMessage:@"Please enter your username and password." onView:self.view];
	} else {
		[[RiverLoadingUtility sharedLoader] startLoading:self.view withFrame:CGRectNull];
		
		[session attemptLoginWithUserName:self.usernameField.text
								 password:self.passwordField.text];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.passwordField)
		[self loginPressed:nil];
	else
		[self.passwordField becomeFirstResponder];
	
	return YES;
}

@end
