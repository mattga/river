//
//  HostViewTableViewController.h
//  River
//
//  Created by Matthew Gardner on 5/5/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiverTableViewController.h"
#import "RoomMemberTableViewCell.h"
#import "RoomSongTableViewCell.h"

@interface HostTableViewController : RiverTableViewController

@property (strong, retain) NSArray *songs;
@property (strong, retain) NSArray *members;
@property (nonatomic) NSInteger selectedTab;

@end
