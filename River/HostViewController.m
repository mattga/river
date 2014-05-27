//
//  HostViewController.m
//  CollabStream
//
//  Created by Matthew Gardner on 2/2/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "HostViewController.h"
#import "RiverAlertUtility.h"

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
    [self addObserver:self forKeyPath:@"appDelegate.syncId" options:0 context:nil];
    [self addObserver:self forKeyPath:@"playbackManager.currentTrack.duration" options:0 context:nil];
	[self addObserver:self forKeyPath:@"playbackManager.trackPosition" options:0 context:nil];
	[self addObserver:self forKeyPath:@"playbackManager.isPlaying" options:0 context:nil];

}

- (void)viewWillAppear:(BOOL)animated {
	
    [super viewWillAppear:animated];
    
    if([[SPSession sharedSession] connectionState] != SP_CONNECTION_STATE_LOGGED_IN) {
		UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"LoginStoryboard_iPhone" bundle:[NSBundle mainBundle]];
		UIViewController *login = [loginSB instantiateViewControllerWithIdentifier:@"SpotifyLogin"];
		[self.navigationController pushViewController:login animated:YES];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	
    hostedRoom = _vars.memberedRoom;
	playbackManager.hostedRoom = hostedRoom;
	
	[self updateLabels];
	
	[super viewDidAppear:animated];
}

- (void)prepareButtons {
	UIImage *minTrack = [[UIImage imageNamed:@"ico_min_track_tint.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 1.0)];
	UIImage *maxTrack = [[UIImage imageNamed:@"ico_max_track_tint.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 1.0)];
	
	[self.trackSlider setMinimumTrackImage:minTrack forState:UIControlStateNormal];
	[self.trackSlider setMaximumTrackImage:maxTrack forState:UIControlStateNormal];
	[self.trackSlider setThumbImage:[UIImage imageNamed:@"ico_slider_thumb.png"] forState:UIControlStateNormal];
	
	[self.volumeSlider setMinimumTrackImage:minTrack forState:UIControlStateNormal];
	[self.volumeSlider setMaximumTrackImage:maxTrack forState:UIControlStateNormal];
	[self.volumeSlider setThumbImage:[UIImage imageNamed:@"ico_slider_thumb.png"] forState:UIControlStateNormal];
	
	// Restore audio controls form background streaming state
    if(playbackManager.isPlaying) {
        _trackSlider.maximumValue = playbackManager.currentTrack.duration;
        _trackSlider.value = playbackManager.trackPosition;
        [_streamButton setHidden:YES];
        [_stopButton setHidden:NO];
    }
}

- (void)updateLabels {
	_songsLabel.text = [NSString stringWithFormat:@"%d Songs", hostedRoom.songs.count];
	_membersLabel.text = [NSString stringWithFormat:@"%d Members", hostedRoom.members.count];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"appDelegate.syncId"]) {
		
		[self updateLabels];
        [hostTVC.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
		
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
        } else {
            [_streamButton setHidden:YES];
            [_stopButton setHidden:NO];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Logic

- (IBAction)setTrackPosition:(id)sender {
	[playbackManager seekToTrackPosition:self.trackSlider.value];
}

- (IBAction)setVolume:(id)sender {
	playbackManager.volume = [(UISlider *)sender value];
}

- (IBAction)skipPressed:(id)sender {
	
	if(hostedRoom == nil || [hostedRoom.songs count] == 0) {
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
		
		if([playbackManager currentTrack] == nil) {
			Track *currentTrack = [_vars.memberedRoom.songs objectAtIndex:0];
			[playbackManager streamSong:currentTrack.trackId withCallback:^{
				[_streamButton setEnabled:YES];
				[_streamButton setHidden:YES];
				[_stopButton setHidden:NO];
			}];
		} else {
			[playbackManager setIsPlaying:YES];
		}
	}
}

- (IBAction)songsPressed:(id)sender {
	[hostTVC setSelectedTab:kHostSongsSelected];
	
	[self.songsButton setBackgroundColor:kRiverLightBlue];
	[self.songsLabel setTextColor:kRiverBGLightGray];
	[self.membersButton setBackgroundColor:kRiverBGLightGray];
	[self.membersLabel setTextColor:kRiverLightBlue];
	
	[hostTVC.tableView reloadData];
}

- (IBAction)membersPressed:(id)sender {
	[hostTVC setSelectedTab:kHostMembersSelected];
	
	[self.songsButton setBackgroundColor:kRiverBGLightGray];
	[self.songsLabel setTextColor:kRiverLightBlue];
	[self.membersButton setBackgroundColor:kRiverLightBlue];
	[self.membersLabel setTextColor:kRiverBGLightGray];
	
	[hostTVC.tableView reloadData];
}

- (void)dealloc {
	[self removeObserver:self forKeyPath:@"appDelegate.syncId"];
	[self removeObserver:self forKeyPath:@"playbackManager.currentTrack.duration"];
	[self removeObserver:self forKeyPath:@"playbackManager.trackPosition"];
	[self removeObserver:self forKeyPath:@"playbackManager.isPlaying"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embedSongsMembers"]) {
		
		[segue.destinationViewController setSongs:[GlobalVars getVar].memberedRoom.songs];
		[segue.destinationViewController setMembers:[GlobalVars getVar].memberedRoom.members];
		
	}
}

@end