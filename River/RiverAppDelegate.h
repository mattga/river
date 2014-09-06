//
//  AppDelegate.h
//  CollabStream
//
//  Created by Matthew Gardner on 1/22/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaLibSpotify.h"
#import "SWRevealViewController.h"

@interface RiverAppDelegate : UIResponder <UIApplicationDelegate, SWRevealViewControllerDelegate> {
    
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) int syncId;
@property (strong, nonatomic) NSArray *songs;
@property (strong, nonatomic) NSArray *members;

@end
