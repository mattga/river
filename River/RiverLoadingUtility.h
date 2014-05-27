//
//  RiverLoadingUtility.h
//  River
//
//  Created by Matthew Gardner on 5/23/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RIVER_LOADING_IMAGE_SIZE 42

@interface RiverLoadingUtility : NSObject {
	NSMutableArray *images;
}

+ (RiverLoadingUtility*)sharedLoader;

- (void)startLoading:(UIView*)onView withFrame:(CGRect)spinnerRect withBackground:(BOOL)showsBgView;
- (void)stopLoading;

@end
