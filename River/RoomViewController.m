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
	
	vars = [GlobalVars getVar];
	_memberedRoom = vars.memberedRoom;
	
	// Set reveal VC delegate
	self.revealViewController.delegate = (id<SWRevealViewControllerDelegate>)[UIApplication sharedApplication].delegate;
}

- (void)viewWillAppear:(BOOL)animated {
    if(_memberedRoom==nil) {
        _hostRoomButton.hidden = NO;
		_joinRoomButton.hidden = NO;
    } else {
        _hostRoomButton.hidden = YES;
		_joinRoomButton.hidden = YES;
    }
    
	self.usernameLabel.text = vars.username;
	
    NSLog(@"Setting room footer for %@", _memberedRoom.roomID);
    self.userTokensLabel.text = (_memberedRoom==nil ? @"0" : [NSString stringWithFormat:@"%d",vars.user.tokens]);
    self.roomLabel.text = (_memberedRoom==nil ? @"-" : [NSString stringWithFormat:@"%@",_memberedRoom.roomID]);
    
    [super viewWillAppear:animated];
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
	self.userTokensLabel.text = [NSString stringWithFormat:@"%d", vars.user.tokens];
	
	if (_memberedRoom !=  nil) {
		if (vars.playingIndex > -1) {
			if (playingSong == nil || ![playingSong.trackId isEqualToString:[(Track*)[_memberedRoom.songs objectAtIndex:vars.playingIndex] trackId]]) {
				playingSong = [_memberedRoom.songs objectAtIndex:vars.playingIndex];
				
				[RiverAuthAccount authorizedRESTCall:kSPLookup withParams:@{@"uri" : playingSong.trackId} callback:^(NSData *response, NSError *err) {
					NSMutableArray *tracksArray = [[NSMutableArray alloc] init];
					SPTracksXMLParser *parser = [[SPTracksXMLParser alloc] initWithData:response outputArray:tracksArray];
					[parser setDelegate:parser];
					[parser parse];
					Track *detailedTrack = [Track trackWithXMLObject:[tracksArray objectAtIndex:0]];
					detailedTrack.trackId = playingSong.trackId;
					detailedTrack.isPlaying = playingSong.isPlaying;
					detailedTrack.currentTokens = playingSong.currentTokens;
					
					playingSong = detailedTrack;
					
					self.trackLabel.text = playingSong.title;
					self.artistLabel.text = playingSong.artist;
					self.albumLabel.text = [NSString stringWithFormat:@"%@ (%@)", playingSong.album, playingSong.released];
					self.trackTokenLabel.text = [NSString stringWithFormat:@"%d", playingSong.currentTokens];
					
					NSURL *url = [NSURL URLWithString:[self fetchAlbumArtForURL:playingSong.trackId]];
					[self.albumArtImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bg_track_placeholder.png"]];
					
					if (!playingViewDown)
						 [self animatePlayingView];
				}];
			}
		} else {
			if (playingViewDown)
				[self dismissPlayingView];
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

- (NSString *)fetchAlbumArtForURL:(NSString *)url {
    NSString *post = @"https://embed.spotify.com/oembed/?url=";
    post = [post stringByAppendingString:url];
    
    NSLog(@"Fetching artwork: %@", post);
    
    // Create the request.
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:post]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];
    
    // Create the connection with the request and start loading the data.
    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:nil];
    
    NSString* dataAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSRange endRange = [dataAsString rangeOfString:@"\",\"provider_name"];

    NSInteger end = endRange.location;
    NSString *artURL = [dataAsString substringToIndex:end];
    
    NSRange startRange = [artURL rangeOfString:@"\"thumbnail_url\":\""];
    NSInteger start = startRange.location + startRange.length;
    artURL = [[artURL substringFromIndex:start] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    
    return artURL;
}

@end
