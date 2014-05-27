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

+ (RiverAlertView*)showOKAlertWithMessage:(NSString*)message;
+ (RiverAlertView*)showOKCancelAlertWithMessage:(NSString*)message okTarget:(id)target okAction:(SEL)action;
+ (RiverAlertView*)showInputAlertWithMessage:(NSString*)message params:(NSDictionary*)params okTarget:(id)target okAction:(SEL)action;
+ (RiverAlertView*)showErrorWithMessage:(NSString*)message;

@end
