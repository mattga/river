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

@interface DiscoverRoomViewController : RiverViewController <NSURLConnectionDelegate> {
	UITableViewController *discoverTVC;
}

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableData *responseData;
@property (weak, nonatomic) IBOutlet UIButton *discoverButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIView *joinContainer;
@property (weak, nonatomic) IBOutlet UIView *discoverContainer;

@property (strong, nonatomic) IBOutlet UIImageView *noRoomsImageView;

- (IBAction)discoverSelected:(id)sender;
- (IBAction)joinSelected:(id)sender;

@end
