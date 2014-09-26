//
//  DiscoverRoomViewController.h
//  River
//
//  Created by Matthew Gardner on 2/22/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiverViewController.h"
#import "MGConnection.h"
#import "DiscoverRoomTableViewController.h"
#import "GlobalVars.h"
#import "Room.h"

@interface DiscoverRoomViewController : RiverViewController <NSURLConnectionDelegate> {
	UITableViewController *discoverTVC;
}

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableData *responseData;
@property (weak, nonatomic) IBOutlet UIButton *discoverButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@end
