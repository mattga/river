//
//  HostViewController.m
//  CollabStream
//
//  Created by Matthew Gardner on 2/2/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "HostViewController.h"
#import "RiverAlertUtility.h"
#import "RiverSPLoginViewController.h"

#define SP_LIBSPOTIFY_DEBUG_LOGGING 1

@interface HostViewController ()

@end

@implementation HostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize
    _vars = [GlobalVars getVar];
    playbackManager = _vars.playbackManager;
	hostTVC = [self.childViewControllers firstObject];
	
	[self prepareButtons];
	
    // AppDelegate instance
    appDelegate = (RiverAppDelegate*)[[UIApplication sharedApplication] delegate];
	
    // Configure observers for player controls
//    [self addObserver:self forKeyPath:@"appDelegate.syncId" options:0 context:nil];
//    [self addObserver:self forKeyPath:@"playbackManager.currentTrack.duration" options:0 context:nil];
//	[self addObserver:self forKeyPath:@"playbackManager.trackPosition" options:0 context:nil];
//	[self addObserver:self forKeyPath:@"playbackManager.isPlaying" options:0 context:nil];
//	[self addObserver:self forKeyPath:@"playbackManager.currentTrack" options:0 context:nil];
	
	self.songsButton.layer.cornerRadius = 20;
	[self.songsButton setTitleColor:kRiverWhite forState:UIControlStateSelected];
	[self.songsButton setTitleColor:kRiverDarkGray forState:UIControlStateNormal];
	
	self.membersButton.layer.cornerRadius = 20;
	[self.membersButton setTitleColor:kRiverWhite forState:UIControlStateSelected];
	[self.membersButton setTitleColor:kRiverDarkGray forState:UIControlStateNormal];
	
	[hostTVC.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
    hostedRoom = _vars.memberedRoom;
	playbackManager.memberedRoom = hostedRoom;
	
	[self updateLabels];
	
}

- (void)viewWillAppear:(BOOL)animated {
	if([[SPSession sharedSession] connectionState] != SP_CONNECTION_STATE_LOGGED_IN) {
		UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"RiverStoryboard_iPhone" bundle:[NSBundle mainBundle]];
		RiverSPLoginViewController *login = [loginSB instantiateViewControllerWithIdentifier:@"SpotifyLogin"];
		[self.navigationController pushViewController:login animated:YES];
	}
}

- (void)prepareButtons {
	
	// Restore audio controls form background streaming state
    if(playbackManager.isPlaying) {
        _trackSlider.maximumValue = playbackManager.currentTrack.duration;
        _trackSlider.value = playbackManager.trackPosition;
        [_streamButton setHidden:YES];
        [_stopButton setHidden:NO];
    }
}

- (void)updateLabels {
	
	self.songsButton.titleLabel.text = [NSString stringWithFormat:@"%d Songs", hostedRoom.songs.count];
	self.membersButton.titleLabel.text = [NSString stringWithFormat:@"%d Members", hostedRoom.members.count];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"appDelegate.syncId"]) {
		@synchronized(hostedRoom) {
			[self performSelectorOnMainThread:@selector(updateLabels) withObject:nil waitUntilDone:NO];
			[hostTVC.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
		}
	} else if ([keyPath isEqualToString:@"playbackManager.currentTrack.duration"]) {
		
		self.trackSlider.maximumValue = playbackManager.currentTrack.duration;
		
	} else if ([keyPath isEqualToString:@"playbackManager.trackPosition"]) {
		
        _trackTime.text = [NSString stringWithFormat:@"%d:%02d", (int)playbackManager.trackPosition/60, (int)playbackManager.trackPosition%60];
        double trackTimeLeft = playbackManager.currentTrack.duration-playbackManager.trackPosition;
        _trackTimeLeft.text = [NSString stringWithFormat:@"%d:%02d", (int)trackTimeLeft/60, (int)trackTimeLeft%60];
		
		// Only update the slider if the user isn't currently dragging it.
		if (!_trackSlider.highlighted) {
			_trackSlider.value = playbackManager.trackPosition;
		}
    } else if ([keyPath isEqualToString:@"playbackManager.isPlaying"]) {
		
        if(playbackManager.isPlaying == NO) {
            [_streamButton setHidden:NO];
            [_stopButton setHidden:YES];
			if (hostedRoom.songs.count == 0) {
				self.currentTrack.text = @"";
			}
        } else {
            [_streamButton setHidden:YES];
            [_stopButton setHidden:NO];
        }
    } else if ([keyPath isEqualToString:@"playbackManager.currentTrack"]) {
		
		self.currentTrack.text = [NSString stringWithFormat:@"%@ - %@",
								  [(SPArtist*)playbackManager.currentTrack.artists.firstObject name],
								  playbackManager.currentTrack.name];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	
//	if (appDelegate != nil) {
//		[self removeObserver:self forKeyPath:@"appDelegate.syncId"];
//		[self removeObserver:self forKeyPath:@"playbackManager.currentTrack.duration"];
//		[self removeObserver:self forKeyPath:@"playbackManager.trackPosition"];
//		[self removeObserver:self forKeyPath:@"playbackManager.isPlaying"];
//		[self removeObserver:self forKeyPath:@"playbackManager.currentTrack"];
//	}
}


#pragma mark - UI Logic

- (IBAction)setTrackPosition:(id)sender {
	[playbackManager seekToTrackPosition:self.trackSlider.value];
}

- (IBAction)skipPressed:(id)sender {
	
	if(hostedRoom == nil || [hostedRoom.songs count] < 1) {
		[RiverAlertUtility showOKAlertWithMessage:@"No track to skip"];
	} else {
		[_nextSong setEnabled:NO];
		
		void (^block)(void) = ^(void) {
			[_nextSong setEnabled:YES];
		};
		
		[playbackManager skipSongWithCallback:block];
	}
}

- (IBAction)pausePressed:(id)sender {
	
	[playbackManager setIsPlaying:NO];
	[_streamButton setHidden:NO];
	[_stopButton setHidden:YES];
}

- (IBAction)playPressed:(id)sender {
	
	if(hostedRoom == nil || [hostedRoom.songs count] == 0)
		[RiverAlertUtility showOKAlertWithMessage:@"No track to play"];
	else {
		[_streamButton setEnabled:NO];
		
		Song *currentTrack;
		@synchronized(_vars.memberedRoom) {
			if (_vars.playingIndex > -1) {
				currentTrack = [_vars.memberedRoom.songs objectAtIndex:_vars.playingIndex];
			}
			currentTrack = [_vars.memberedRoom.songs objectAtIndex:0];
		}
		
		if([playbackManager currentTrack] == nil) {
			[playbackManager streamSong:currentTrack.trackId withCallback:^{
				[_streamButton setEnabled:YES];
				[_streamButton setHidden:YES];
				[_stopButton setHidden:NO];
				
				self.currentTrack.text = [NSString stringWithFormat:@"%@ - %@",
										  currentTrack.artist,
										  currentTrack.title];
			}];
		} else {
			[playbackManager setIsPlaying:YES];
			[_streamButton setEnabled:YES];
		}
	}
}

- (IBAction)songsPressed:(id)sender {
	[hostTVC setSelectedTab:kHostSongsSelected];
	
	self.songsButton.selected = YES;
	self.membersButton.selected = NO;
	[self.songsButton setBackgroundColor:kRiverLightBlue];
	[self.membersButton setBackgroundColor:kRiverBGLightGray];
	
	[hostTVC.tableView reloadData];
}

- (IBAction)membersPressed:(id)sender {
	[hostTVC setSelectedTab:kHostMembersSelected];
	
	self.songsButton.selected = NO;
	self.membersButton.selected = YES;
	[self.songsButton setBackgroundColor:kRiverBGLightGray];
	[self.membersButton setBackgroundColor:kRiverLightBlue];
	
	[hostTVC.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embedSongsMembers"]) {
		
	}
}

@end