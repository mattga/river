//
//  RiverLoadingUtility.m
//  River
//
//  Created by Matthew Gardner on 5/23/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverLoadingUtility.h"
#import "RiverAppDelegate.h"
#import "Constants.h"

@implementation RiverLoadingUtility
static RiverLoadingUtility *loadingUtility;
static UIView *loadingView;
static bool isLoading;

+ (RiverLoadingUtility*)sharedLoader
{
    if (loadingUtility == nil)
    {
        loadingUtility = [[RiverLoadingUtility alloc] init];
    }
    
    return loadingUtility;
}

- (id)init
{
    images = [[NSMutableArray alloc] init];
    
    UIImage* image = NULL;
    
	for (unsigned int count = 0; count < 120; count++) {
        NSString* formatString = @"River_Loader_%03d.png";
        NSString* imageName = [NSString stringWithFormat:formatString, count];
        image = [UIImage imageNamed:imageName];
        if(image != NULL)
        {
            [images addObject:image];
        }
    }
	
    return self;
}

- (void)startLoading:(UIView*)onView withFrame:(CGRect)spinnerRect withBackground:(BOOL)showsBgView
{
    if (onView == nil && loadingView == nil) {
		UIWindow *window = [[UIApplication sharedApplication] keyWindow];
		loadingView = window.rootViewController.view;
	} else if (loadingView != nil) {
		NSLog(@"RiverLoadingUtility::StartLoading() - Loader called on %@ when loading already active %@", onView, loadingView);
	} else {
		loadingView = onView;
	}
	
	UIImage *firstImage = [images firstObject];
	
	UIImageView *loaderImageView = [[UIImageView alloc] initWithImage:firstImage];
	loaderImageView.animationImages = images;
	loaderImageView.animationDuration = 2;
	
	loaderImageView.contentMode = UIViewContentModeScaleAspectFit;
	
	UIView *loaderOverlay = [[UIView alloc] init];
	
	if (CGRectIsNull(spinnerRect)) {
		loaderOverlay.frame = onView.frame;
		loaderImageView.frame = CGRectMake((onView.frame.size.width / 2) - (RIVER_LOADING_IMAGE_SIZE / 2),
										   (onView.frame.size.height / 2) - (RIVER_LOADING_IMAGE_SIZE / 2),
										   RIVER_LOADING_IMAGE_SIZE,
										   RIVER_LOADING_IMAGE_SIZE);
	} else {
		loaderOverlay.frame = spinnerRect;
		loaderImageView.frame = CGRectMake((spinnerRect.size.width / 2) - (RIVER_LOADING_IMAGE_SIZE / 2),
										   (spinnerRect.size.height / 2) - (RIVER_LOADING_IMAGE_SIZE / 2),
										   RIVER_LOADING_IMAGE_SIZE,
										   RIVER_LOADING_IMAGE_SIZE);
	}
	
	if (showsBgView) {
		[loaderOverlay setBackgroundColor:kRiverBGLightGray_60];
	}
	
	[loaderOverlay addSubview:loaderImageView];
	
	[loaderImageView startAnimating];
	
	[loadingView addSubview:loaderOverlay];
}

- (void)stopLoading
{
	[[[(UIView*)[loadingView.subviews lastObject] subviews] lastObject] stopAnimating];
	[[loadingView.subviews lastObject] removeFromSuperview];
	
	loadingView = nil;
}

@end
