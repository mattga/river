//
//  TrackDetailTableViewController.h
//  River
//
//  Created by Matthew Gardner on 3/4/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiverAlertUtility.h"
#import "RiverViewController.h"
#import "Song.h"
#import "Room.h"

@interface TrackDetailViewController : RiverViewController <UIScrollViewDelegate> {
	Room *memberedRoom;
	RiverAlertView *bidAlert;
}

@property (strong, nonatomic) NSDictionary *track;
@property (strong, nonatomic) NSDictionary *album;
@property (strong, nonatomic) NSMutableData *responseData;

@property (strong, nonatomic) UIImageView *pointsImageView;
@property (strong, nonatomic) UILabel *pointsLabel;

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tokenLabel;
@property (strong, nonatomic) IBOutlet UILabel *roomLabel;
@property (strong, nonatomic) IBOutlet UIImageView *albumArtView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UILabel *albumLabel;
@property (strong, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)requestSong:(id)sender;

@end
