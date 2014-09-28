//
//  RiverAlertUtility.m
//  River
//
//  Created by Matthew Gardner on 5/19/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverAlertUtility.h"

#define ALERT_TEXTVIEW_ADDITION			20
#define ALERT_TEXTVIEW_PADDING			10
#define ALERT_INPUT_PADDING				30
#define ALERT_BUTTON_HEIGHT				40

@implementation RiverAlertUtility

+ (UIAlertView*)showOKAlertWithMessage:(NSString*)message {

	/*RiverAlertView *alertView = [[RiverAlertView alloc] initWithContents:@"RiverOKAlertView"];
	
	CGRect textFrame = [message boundingRectWithSize:alertView.alertMessageView.frame.size
										 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
									  attributes:@{NSFontAttributeName : [UIFont fontWithName:kGothamLight size:18.0f]}
										 context:nil];
	
	CGSize screen = [UIScreen mainScreen].bounds.size;
	CGSize size = CGSizeMake(alertView.frame.size.width,
							 (ALERT_TEXTVIEW_PADDING*2) + textFrame.size.height + ALERT_TEXTVIEW_ADDITION + ALERT_BUTTON_HEIGHT);
												   
	CGRect frame = CGRectMake((screen.width/2) - (size.width/2),
					   (screen.height/3) - (size.height/2),
					   size.width,
					   size.height);
	
	alertView.alertMessageView.text = message;
	alertView.alertMessageView.font = [UIFont fontWithName:kGothamLight size:18.0f];
	alertView.alertMessageView.textColor = kRiverBGLightGray;
	alertView.alertMessageView.textAlignment = NSTextAlignmentCenter;
	alertView.alertMessageView.frame = CGRectMake(textFrame.origin.x,
												  textFrame.origin.y,
												  textFrame.size.width,
												  textFrame.size.height + ALERT_TEXTVIEW_ADDITION);
	alertView.frame = frame;
	[alertView setAlpha:0.0f];
	
	if (view == nil) {
		UIWindow *window = [[UIApplication sharedApplication] keyWindow];
		view = window.rootViewController.view;
	}
	[view addSubview:alertView];
	
	[UIView animateWithDuration:.5
						  delay:0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 [alertView setAlpha:1.0f];
					 }
					 completion:^(BOOL finished) {
						 
					 }];*/
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
														message:message
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil, nil];
	[alertView show];
	
	return alertView;
}

+ (UIAlertView*)showErrorMessage:(NSString*)message {
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
														message:message
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil, nil];
	[alertView show];
	
	return alertView;
}

+ (RiverAlertView *)showOKCancelAlertWithMessage:(NSString *)message onView:(UIView*)view okTarget:(id)target okAction:(SEL)action {
	
	// TODO: showOKCancelAlertWithMessage
	
	return nil;
}

+ (RiverAlertView*)showInputAlertWithMessage:(NSString*)message onView:(UIView*)view params:(NSDictionary*)params okTarget:(id)target okAction:(SEL)action {
	
	RiverAlertView *alertView = [[RiverAlertView alloc] initWithContents:@"RiverInputAlertView"];
	
	CGRect textFrame = [message boundingRectWithSize:alertView.alertMessageView.frame.size
										 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
									  attributes:@{NSFontAttributeName : [UIFont fontWithName:kGothamLight size:18.0f]}
										 context:nil];
	
	CGSize screen = [UIScreen mainScreen].bounds.size;
	CGSize size = CGSizeMake(alertView.frame.size.width,
							 ALERT_TEXTVIEW_PADDING + textFrame.size.height + ALERT_TEXTVIEW_ADDITION + alertView.inputField.frame.size.height + ALERT_INPUT_PADDING + ALERT_BUTTON_HEIGHT);
	CGRect frame = CGRectMake((screen.width/2) - (size.width/2),
					   (screen.height/3) - (size.height/2),
					   size.width,
					   size.height);
	
	alertView.alertMessageView.text = message;
	alertView.alertMessageView.font = [UIFont fontWithName:kGothamLight size:18.0f];
	alertView.alertMessageView.textColor = kRiverBGLightGray;
	alertView.alertMessageView.textAlignment = NSTextAlignmentCenter;
	alertView.alertMessageView.frame = CGRectMake(textFrame.origin.x,
												  textFrame.origin.y,
												  textFrame.size.width,
												  textFrame.size.height + ALERT_TEXTVIEW_ADDITION);
	alertView.frame = frame;
	[alertView setAlpha:0.0f];
	
	if ([params objectForKey:@"keyboardType"] != nil) {
		[alertView.inputField setKeyboardType:[[params objectForKey:@"keyboardType"] intValue]];
	}
	if ([params objectForKey:@"initialValue"] != nil) {
		alertView.inputField.text = [params objectForKey:@"initialValue"];
	}
	
	if (target != nil && action != nil) {
		[[alertView okButton] addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	}
	
	if (view == nil) {
		UIWindow *window = [[UIApplication sharedApplication] keyWindow];
		view = window.rootViewController.view;
	}
	[view addSubview:alertView];
	
	[UIView animateWithDuration:.5
						  delay:0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 [alertView setAlpha:1.0f];
					 }
					 completion:^(BOOL finished) {
						 
					 }];
	
	return alertView;
}

@end
