//
//  UINavigationController+RootDebug.m
//  River
//
//  Created by Matthew Gardner on 7/14/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "UINavigationController+RootDebug.h"

@implementation UINavigationController (RootDebug)

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
	NSLog(@"Root view controller: %@", [[self.viewControllers firstObject] class]);
	return [self popToRootViewControllerAnimated:animated];
}

@end
