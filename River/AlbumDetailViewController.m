//
//  AlbumDetailViewController.m
//  River
//
//  Created by Matthew Gardner on 3/10/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "AlbumDetailViewController.h"
#import "SPTracksXMLParser.h"
#import "GlobalVars.h"
#import "TrackDetailViewController.h"
#import "SVProgressHUD.h"
#import "SPJSONParser.h"

@interface AlbumDetailViewController ()

@end

@implementation AlbumDetailViewController
@synthesize tracks;

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
	// Do any additional setup after loading the view.
	
	[SVProgressHUD show];
	
	[self fetchAlbumDetails];
	
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)prepareLabels {
	
	// Set album labels. Substring release_date to only get year...
	self.albumLabel.text = [self.album objectForKey:@"name"];
	self.artistLabel.text = [[[self.album objectForKey:@"artists"] firstObject] objectForKey:@"name"];
	self.releasedLabel.text = [[self.album objectForKey:@"released_date"] substringToIndex:4];
	
	// Fetch album art
	NSURL *url = [SPJSONParser imageURLFromSPJSON:self.album withSize:kRiverAlbumArtMedium];
	[self.albumArtImage setImageWithURL:url];
	
	// Set footer labels
	[self.userLabel setText:[[RiverAuthController sharedAuth] currentUser].DisplayName];
	[self.roomLabel setText:[GlobalVars getVar].memberedRoom.roomName];
	[self.tokenLabel setText:[NSString stringWithFormat:@"%d", [[RiverAuthController sharedAuth] currentUser].Tokens]];
}

- (void)fetchAlbumDetails {
	if (self.albumId) {
		[RiverAuthController authorizedSPQuery:kSPAlbums
										action:nil
										   _id:self.albumId
										  verb:kRiverGet
									withParams:nil
									  callback:^(NSDictionary *object, NSError *err) {
										  
										  if (!err) {
											  
											  self.album = object;
											  self.tracks = [SPJSONParser tracksFromSPJSON:self.album];
											  [self prepareLabels];
											  
											  [tracksTVC.tableView reloadData];
										  }
										  
										  [SVProgressHUD dismiss];
									  }];
	}
}

- (IBAction)backPressed:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embedAlbumTracks"]) {
		tracksTVC = segue.destinationViewController;
	} else if ([segue.identifier isEqualToString:@"trackDetailSegue"]) {
		[(TrackDetailViewController*)segue.destinationViewController setTrack:[tracks objectAtIndex:[(NSIndexPath*)sender row]]];
		[(TrackDetailViewController*)segue.destinationViewController setAlbum:self.album];
	}
}

@end
