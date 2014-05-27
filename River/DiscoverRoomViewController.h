//
//  DiscoverRoomViewController.h
//  River
//
//  Created by Matthew Gardner on 2/22/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiverViewController.h"
#import "RiverConnection.h"
#import "DiscoverRoomTableViewController.h"
#import "SWRevealViewController.h"
#import "GlobalVars.h"
#import "Room.h"

@interface DiscoverRoomViewController : RiverViewController <NSURLConnectionDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableData *responseData;

@property (strong, nonatomic) IBOutlet UIImageView *noRoomsImageView;

@end
