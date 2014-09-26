//
//  RoomViewController.m
//  River
//
//  Created by Matthew Gardner on 2/22/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RoomViewController.h"

@interface RoomViewController ()

@end

@implementation RoomViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	
    [super viewWillAppear:animated];
	
	vars = [GlobalVars getVar];
	_memberedRoom = vars.memberedRoom;
	
    if(_memberedRoom==nil) {
        _hostRoomButton.hidden = NO;
		_joinRoomButton.hidden = NO;
    } else {
        _hostRoomButton.hidden = YES;
		_joinRoomButton.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	[roomTVC.tableView reloadData];
	
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hostARoomPressed:(id)sender {
	[self performSegueWithIdentifier:@"hostSegue" sender:sender];
}

- (IBAction)joinARoomPressed:(id)sender {
	[self performSegueWithIdentifier:@"joinSegue" sender:sender];
}

- (void)reloadRoomData {
	
	if (_memberedRoom !=  nil) {
		if (vars.playingIndex > -1 && vars.playingIndex < self.memberedRoom.songs.count) {
			if (playingSong == nil || ![playingSong.trackId isEqualToString:[(Song*)[_memberedRoom.songs objectAtIndex:vars.playingIndex] trackId]]) {
				NSLog(@"playingIndex: %d  songsCount: %d", vars.playingIndex, self.memberedRoom.songs.count);
				playingSong = [_memberedRoom.songs objectAtIndex:vars.playingIndex];
				
				self.trackLabel.text = playingSong.title;
				self.artistLabel.text = playingSong.artist;
				self.albumLabel.text = [NSString stringWithFormat:@"%@ (%@)", playingSong.album, playingSong.year];
				self.trackTokenLabel.text = [NSString stringWithFormat:@"%d", playingSong.tokens.intValue];
				
				NSURL *url = [NSURL URLWithString:playingSong.albumArtURL];
				[self.albumArtImageView setImageWithURL:url];
				
				if (!playingViewDown) {
					[self animatePlayingView];
				}
			}
		} else {
			if (playingViewDown) {
				[self dismissPlayingView];
			}
		}
	}
}

- (void)animatePlayingView {
	NSLog(@"Playing View DOWN");
	
	[UIView animateWithDuration:1.0
                     animations:^{
						 self.containerTopSpaceConstraint.constant += 151.0f;
						 [self.view layoutSubviews];
						 [self.playlistContainer layoutSubviews];
						 [self.view layoutIfNeeded];
                     }
					 completion:^(BOOL finished) {
						 if (finished)
							 playingViewDown = YES;
					 }];
}

- (void)dismissPlayingView {
	NSLog(@"Playing View UP");
	
	self.containerTopSpaceConstraint.constant -= 151.0f;
	[UIView animateWithDuration:1.0
                     animations:^{
						 [self.view layoutSubviews];
						 [self.playlistContainer layoutSubviews];
                     }
					 completion:^(BOOL finished) {
						 if (finished)
							 playingViewDown = NO;
					 }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embedRoomTable"]) {
		roomTVC = segue.destinationViewController;
	} else if ([segue.identifier isEqualToString:@"hostSegue"]) {
		
		UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"RiverStoryboard_iPhone" bundle:[NSBundle mainBundle]];
		UIViewController *login = [loginSB instantiateViewControllerWithIdentifier:@"SpotifyLogin"];
		[self.navigationController pushViewController:login animated:YES];
	} else if ([segue.identifier isEqualToString:@"joinSegue"]) {
	}
}

@end
