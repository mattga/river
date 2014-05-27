//
//  TrackDetailTableViewController.m
//  River
//
//  Created by Matthew Gardner on 3/4/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "TrackDetailViewController.h"
#import "GlobalVars.h"
#import "RiverAuthAccount.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TrackDetailViewController ()

@end

@implementation TrackDetailViewController

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

}

- (void)viewDidAppear:(BOOL)animated {
	
	[self prepareLabels];
	
	[super viewDidAppear:animated];
}

- (void)prepareLabels {
	// Populate labels...
	memberedRoom = [GlobalVars getVar].memberedRoom;
	
    if(memberedRoom != nil) {
        NSLog(@"membered room %@",[GlobalVars getVar].memberedRoom.roomID);
        _roomLabel.text = [GlobalVars getVar].memberedRoom.roomID;
        _usernameLabel.text = [GlobalVars getVar].username;
        _tokenLabel.text = [NSString stringWithFormat:@"%d",[GlobalVars getVar].user.tokens];
    } else {
        _roomLabel.text = @"-";
        _tokenLabel.text = @"0";
    }
	
    _titleLabel.text = [_track objectForKey:@"track_name"];
    _artistLabel.text = [_track objectForKey:@"artist_name"];
    _albumLabel.text = [NSString stringWithFormat:@"%@ (%@)",[_track objectForKey:@"album_name"],[_track objectForKey:@"album_released"]];
    double length = [[_track objectForKey:@"length"] doubleValue];
    _lengthLabel.text = [NSString stringWithFormat:@"%d:%d", (int)length/60, (int)length%60];
}

- (void)viewDidLayoutSubviews {
    [self.scrollView setContentSize:CGSizeMake(320, 468)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestSong:(id)sender {
    
	bidAlert = [RiverAlertUtility showInputAlertWithMessage:@"How many tokens would you like to add to this track?"
													 params:@{@"keyboardType" : @((int)UIKeyboardTypeNumberPad),
															  @"initialValue" : @"10"}
												   okTarget:self
												   okAction:@selector(makeBid:)];
}

- (void)makeBid:(UIButton*)button {
	int bid = [bidAlert.inputField.text intValue];
	
	if (bid < 10) {
		[bidAlert removeFromSuperview];
		
        [RiverAlertUtility showOKAlertWithMessage:@"Requesting a song requires a minimum of 10 tokens!"];
    } else if([GlobalVars getVar].memberedRoom == nil) {
		[bidAlert removeFromSuperview];
		
        [RiverAlertUtility showOKAlertWithMessage:@"You must join a room before requesting a song."];
	} else {
		[RiverAuthAccount authorizedRESTCall:kRiverRESTAddSong withParams:@{@"groupId" : memberedRoom.roomID,
																			@"userId" : [RiverAuthAccount sharedAuth].userId,
																			@"songId" : [_track objectForKey:@"track_href"],
																			@"title" : [_track objectForKey:@"track_name"],
																			@"artist" : [_track objectForKey:@"artist_name"],
																			@"points" : @((int)bid)}
									callback:^(NSData *response, NSError *err) {
										if (!err) {
											NSString *responseText = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
											if([responseText isEqualToString:[NSString stringWithFormat:@"Success adding points to song %@", [_track objectForKey:@"track_href"]]]) {
												
												NSLog(@"%d tokens added to %@", bid, [_track objectForKey:@"track_href"]);
												
												[RiverAlertUtility showOKAlertWithMessage:[NSString stringWithFormat:@"%d tokens added to %@", bid, [_track objectForKey:@"track_name"]]];
											} else if ([responseText isEqualToString:[NSString stringWithFormat:@"Success adding song %@", [_track objectForKey:@"track_href"]]]) {
												
												[RiverAlertUtility showOKAlertWithMessage:[NSString stringWithFormat:@"Your song, %@ has been added with %d tokens.", [_track objectForKey:@"track_name"], bid]];
											} else {
												
												[RiverAlertUtility showErrorWithMessage:responseText];
											}
														[bidAlert removeFromSuperview];
										}
									}];
    }
}

- (NSString *)fetchAlbumArtForURL:(NSString *)url {
    NSString *post = @"https://embed.spotify.com/oembed/?url=";
    post = [post stringByAppendingString:url];
    
    //    NSLog(@"Posting query: %@", post);
    
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
