//
//  DiscoverRoomTableViewController.h
//  River
//
//  Created by Matthew Gardner on 4/27/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiverTableViewController.h"
#import "DiscoverRoomTableViewCell.h"
#import "GlobalVars.h"
#import "RiverAuthController.h"
#import "MGConnection.h"

@interface DiscoverRoomTableViewController : RiverTableViewController

// Passed data
@property (nonatomic, strong) NSMutableArray *rooms;
@property (nonatomic) int selectedRoom;

- (void) reloadRooms;

@end
