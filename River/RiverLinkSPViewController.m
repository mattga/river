//
//  RiverChooseSPViewController.m
//  River
//
//  Created by Matthew Gardner on 9/27/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverLinkSPViewController.h"

@implementation RiverLinkSPViewController

- (IBAction)noSPPressed:(id)sender {
	
	UINavigationController *nvc = [[[[UIApplication sharedApplication].delegate.window rootViewController] childViewControllers] firstObject];
	NSMutableArray *vcs = [[nvc viewControllers] mutableCopy];
	[vcs removeLastObject];
	[vcs removeLastObject];
	[vcs removeLastObject];
	[nvc setViewControllers:vcs animated:YES];
	[vcs.firstObject tabBarController].tabBar.hidden = NO;
}

@end
