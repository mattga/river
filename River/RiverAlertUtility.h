//
//  RiverAlertUtility.h
//  River
//
//  Created by Matthew Gardner on 5/19/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RiverAlertView.h"
#import "Constants.h"

@interface RiverAlertUtility : NSObject

+ (UIAlertView*)showOKAlertWithMessage:(NSString*)message;
+ (UIAlertView*)showErrorMessage:(NSString*)message;
+ (RiverAlertView*)showOKCancelAlertWithMessage:(NSString*)message onView:(UIView*)view okTarget:(id)target okAction:(SEL)action;
+ (RiverAlertView*)showInputAlertWithMessage:(NSString*)message onView:(UIView*)view params:(NSDictionary*)params okTarget:(id)target okAction:(SEL)action;

@end
