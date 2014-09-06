//
//  RoomViewController.h
//  River
//
//  Created by Matthew Gardner on 2/22/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AddSongViewController.h"
#import "RiverViewController.h"
#import "Room.h"
#import "User.h"
#import "Song.h"
#import "RiverAppDelegate.h"
#import "RiverAuthAccount.h"
#import "RoomSongTableViewCell.h"
#import "SPTracksXMLParser.h"

@interface RoomViewController : RiverViewController {
    UITableViewController *roomTVC;
	GlobalVars *vars;
	Song *playingSong;
	BOOL playingViewDown;
}

// Passed in data
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Room *memberedRoom;

// UI
@property (weak, nonatomic) IBOutlet UIButton *addSongButton;
@property (weak, nonatomic) IBOutlet UIView *playlistContainer;
@property (weak, nonatomic) IBOutlet UIView *containerAnimateView;

@property (weak, nonatomic) IBOutlet UIImageView *albumArtImageView;
@property (weak, nonatomic) IBOutlet UILabel *trackLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *trackPosition;
@property (weak, nonatomic) IBOutlet UILabel *timeElapsed;
@property (weak, nonatomic) IBOutlet UILabel *trackTokenLabel;

@property (weak, nonatomic) IBOutlet UIButton *hostRoomButton;
@property (weak, nonatomic) IBOutlet UIButton *joinRoomButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerTopSpaceConstraint;

- (IBAction)hostARoomPressed:(id)sender;
- (IBAction)joinARoomPressed:(id)sender;

- (void)reloadRoomData;
- (void)animatePlayingView;
- (void)dismissPlayingView;

@end
