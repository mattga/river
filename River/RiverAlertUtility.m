//
//  RiverAlertUtility.m
//  River
//
//  Created by Matthew Gardner on 5/19/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverAlertUtility.h"

#define ALERT_TEXTVIEW_ADDITION			5
#define ALERT_TEXTVIEW_PADDING			10
#define ALERT_INPUT_PADDING				30
#define ALERT_BUTTON_HEIGHT				40

@implementation RiverAlertUtility

+ (RiverAlertView*)showOKAlertWithMessage:(NSString*)message {

	RiverAlertView *alertView = [[RiverAlertView alloc] initWithContents:@"RiverOKAlertView"];
	
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
	
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	
	[UIView animateWithDuration:.5
						  delay:0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 [window.rootViewController.view addSubview:alertView];
					 }
					 completion:^(BOOL finished) {
						 
					 }];
	
	return alertView;
}

+ (RiverAlertView *)showOKCancelAlertWithMessage:(NSString *)message okTarget:(id)target okAction:(SEL)action {
	
	// TODO: showOKCancelAlertWithMessage
	
	return nil;
}

+ (RiverAlertView*)showInputAlertWithMessage:(NSString*)message params:(NSDictionary*)params okTarget:(id)target okAction:(SEL)action {
	
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
	
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	[window.rootViewController.view addSubview:alertView];
	
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

+ (UIAlertView *)showErrorWithMessage:(NSString *)message {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
													 message:message
													delegate:nil
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil];
	
	[alert show];
	
	return alert;
}

@end
