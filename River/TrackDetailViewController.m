//
//  TrackDetailTableViewController.m
//  River
//
//  Created by Matthew Gardner on 3/4/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "TrackDetailViewController.h"
#import "GlobalVars.h"
#import "RiverAuthAccount.h"
#import "SPJSONParser.h"
#import "RiverSyncUtility.h"

@interface TrackDetailViewController ()

@end

@implementation TrackDetailViewController
@synthesize track, album;

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
	
	if (!album) {
		[self fetchAlbumDetails];
	} else {
		self.albumLabel.text = [NSString stringWithFormat:@"%@ (%@)", [album objectForKey:@"name"], [[album objectForKey:@"release_date"] substringToIndex:4]];
		
		[self prepareLabels];
	}
	
}

- (void)prepareLabels {
	// Populate labels...
	memberedRoom = [GlobalVars getVar].memberedRoom;
	
	self.usernameLabel.text = [RiverAuthAccount sharedAuth].username;
    if(memberedRoom != nil) {
        NSLog(@"membered room %@",[GlobalVars getVar].memberedRoom.roomName);
        self.roomLabel.text = [GlobalVars getVar].memberedRoom.roomName;
        self.tokenLabel.text = [NSString stringWithFormat:@"%d",[RiverAuthAccount sharedAuth].currentUser.tokens];
    } else {
        self.roomLabel.text = @"-";
        self.tokenLabel.text = @"-";
    }
	
    self.titleLabel.text = [track objectForKey:@"name"];
    self.artistLabel.text = [[[track objectForKey:@"artists"] firstObject] objectForKey:@"name"];
    double length = [[track objectForKey:@"duration_ms"] doubleValue]/1e3;
    self.lengthLabel.text = [NSString stringWithFormat:@"%d:%02d", (int)length/60, (int)length%60];
	
	NSURL *url= [SPJSONParser imageURLFromSPJSON:album withSize:280];
	[_albumArtView setImageWithURL:url];
}

- (void)viewDidLayoutSubviews {
    [self.scrollView setContentSize:CGSizeMake(320, 468)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchAlbumDetails {
	[RiverAuthAccount authorizedRESTCall:kSPRESTAlbums
								  action:nil
									verb:kRiverGet
									 _id:[[track objectForKey:@"album"] objectForKey:@"id"]
							  withParams:nil
								callback:^(NSDictionary *object, NSError *err) {
									
									if (!err) {
										album = object;
										self.albumLabel.text = [NSString stringWithFormat:@"%@ (%@)", [album objectForKey:@"name"], [[album objectForKey:@"release_date"] substringToIndex:4]];
										
										[self prepareLabels];
									}
								}];
}

- (IBAction)requestSong:(id)sender {
    
	bidAlert = [RiverAlertUtility showInputAlertWithMessage:@"How many tokens would you like to add to this track?"
													 onView:self.view
													 params:@{@"keyboardType" : @((int)UIKeyboardTypeNumberPad),
															  @"initialValue" : @"10"}
												   okTarget:self
												   okAction:@selector(makeBid:)];
}

- (void)makeBid:(UIButton*)button {
	int bid = [bidAlert.inputField.text intValue];
	
	if (bid < 10) {
		[bidAlert removeFromSuperview];
		
        [RiverAlertUtility showOKAlertWithMessage:@"Requesting a song requires a minimum of 10 tokens!"
										   onView:self.view];
    } else if([GlobalVars getVar].memberedRoom == nil) {
		[bidAlert removeFromSuperview];
		
        [RiverAlertUtility showOKAlertWithMessage:@"You must join a room before requesting a song."
										   onView:self.view];
	} else {
		[button setEnabled:NO];
		
		NSMutableDictionary *dict = [@{} mutableCopy];
		if ([track objectForKey:@"uri"] != nil) {
			[dict setObject:[track objectForKey:@"uri"] forKey:@"ProviderId"];
		}
		if ([track objectForKey:@"name"] != nil) {
			[dict setObject:[track objectForKey:@"name"] forKey:@"SongName"];
		}
		if ([[[track objectForKey:@"artists"] firstObject] objectForKey:@"name"] != nil) {
			[dict setObject:[[[track objectForKey:@"artists"] firstObject] objectForKey:@"name"] forKey:@"SongArtist"];
		}
		if ([album objectForKey:@"name"] != nil) {
			[dict setObject:[album objectForKey:@"name"] forKey:@"SongAlbum"];
		}
		if ([album objectForKey:@"images"] != nil) {
			[dict setObject:[SPJSONParser imageURLFromSPJSON:album withSize:kRiverAlbumArtMedium] forKey:@"AlbumArtURL"];
		}
		if ([track objectForKey:@"duration_ms"] != nil) {
			[dict setObject:@((int)([[track objectForKey:@"duration_ms"] intValue] / 1e3)) forKey:@"SongLength"];
		}
		if ([album objectForKey:@"release_date"] != nil) {
			[dict setObject:[[album objectForKey:@"release_date"] substringToIndex:4] forKey:@"SongYear"];
		}
		if (@((int)bid) != nil) {
			[dict setObject:@((int)bid) forKey:@"Tokens"];
		}
		
		[RiverAuthAccount authorizedRESTCall:kRiverRESTRoom
									  action:kRiverActionAddSong
										verb:kRiverPost
										 _id:@"1"
								  withParams:@{@"RoomName" : memberedRoom.roomName,
											   @"Users" : @[@{@"User" : @{@"Username" : [RiverAuthAccount sharedAuth].username}}],
											   @"Songs" : @[dict]}
									callback:^(NSDictionary *object, NSError *err) {
										
										if (!err) {
											
											RiverStatus *status = [[RiverStatus alloc] init];
											[status readFromJSONObject:object];
											
											if(status.statusCode.intValue == kRiverStatusAlreadyExists) {
												
												[[RiverSyncUtility sharedSyncing] preemptRoomSync];
												
												NSLog(@"%d tokens added to %@", bid, [track objectForKey:@"track_href"]);
												
												[self.navigationController popToRootViewControllerAnimated:YES];
												
												[RiverAlertUtility showOKAlertWithMessage:[NSString stringWithFormat:@"%d tokens added to %@", bid, [track objectForKey:@"track_name"]]
																				   onView:self.view];
											} else if (status.statusCode.intValue == kRiverStatusOK) {
												
												[[RiverSyncUtility sharedSyncing] preemptRoomSync];
												
												[self.navigationController popToRootViewControllerAnimated:YES];
												
												[RiverAlertUtility showOKAlertWithMessage:[NSString stringWithFormat:@"%@ has been added with %d tokens.", [track objectForKey:@"track_name"], bid]
																				   onView:self.view];
											} else {
												
												[RiverAlertUtility showOKAlertWithMessage:@"ERROR"
																				   onView:self.view];
											}
											
											[button setEnabled:YES];
											[bidAlert removeFromSuperview];
										}
									}];
    }
}


@end
