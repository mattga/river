//
//  RoomTableViewController.h
//  River
//
//  Created by Matthew Gardner on 4/27/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiverAppDelegate.h"
#import "GlobalVars.h"
#import "RiverTableViewController.h"
#import "RoomViewController.h"
#import "RoomSongTableViewCell.h"

@interface RoomTableViewController : RiverTableViewController {
    RiverAppDelegate *appDelegate;
	Room *memberedRoom;
	Song *selectedTrack;
	RiverAlertView *bidAlert;
}

@end
