//
//  HostViewController.h
//  CollabStream
//
//  Created by Matthew Gardner on 2/2/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaLibSpotify.h"
#import "SPLoginViewController.h"
#import "CreateRoomViewController.h"
#import "LoginWarningDelegate.h"
#import "Room.h"
#import "User.h"
#import "Track.h"
#import "RiverPlaybackManager.h"
#import "RiverViewController.h"
#import "RiverAppDelegate.h"
#import "GlobalVars.h"
#import "HostTableViewController.h"

@interface HostViewController : RiverViewController <NSURLConnectionDelegate> {
	RiverAppDelegate *appDelegate;
	HostTableViewController *hostTVC;
	RiverPlaybackManager *playbackManager;
	Room *hostedRoom;
}

// Variables
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) GlobalVars *vars;
// Storyboard UI
@property (strong, nonatomic) IBOutlet UILabel *trackTime;
@property (strong, nonatomic) IBOutlet UILabel *trackTimeLeft;
@property (weak, nonatomic) IBOutlet UIButton *songsButton;
@property (weak, nonatomic) IBOutlet UILabel *songsLabel;
@property (weak, nonatomic) IBOutlet UIButton *membersButton;
@property (weak, nonatomic) IBOutlet UILabel *membersLabel;

// Player UI
@property (strong, nonatomic) IBOutlet UIButton *streamButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *nextSong;
@property (strong, nonatomic) IBOutlet UISlider *trackSlider;
@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;

// Manual UI
@property (strong, nonatomic) CreateRoomViewController *createRoomView;
@property (strong, nonatomic) SPLoginViewController *spLoginView;
@property (strong, nonatomic) UIView *loginWarning;

- (IBAction)setTrackPosition:(id)sender;
- (IBAction)setVolume:(id)sender;
- (IBAction)skipPressed:(id)sender;
- (IBAction)pausePressed:(id)sender;
- (IBAction)playPressed:(id)sender;
- (IBAction)songsPressed:(id)sender;
- (IBAction)membersPressed:(id)sender;

@end
