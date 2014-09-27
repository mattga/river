//
//  ArtistDetailTableViewController.m
//  River
//
//  Created by Matthew Gardner on 3/10/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "ArtistDetailViewController.h"
#import "SPAlbumsXMLParser.h"
#import "GlobalVars.h"
#import "AlbumDetailViewController.h"
#import "ResultsAlbumTableViewCell.h"
#import "SVProgressHUD.h"
#import "SPJSONParser.h"

@interface ArtistDetailViewController ()

@end

@implementation ArtistDetailViewController
@synthesize artistName, artistId;

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
	
	[SVProgressHUD show];
	
	[self fetchArtistDetails];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)prepareLabels {
	[self.artistLabel setText:artistName];
	
	// Set footer labels
	[self.userLabel setText:[[RiverAuthController sharedAuth] currentUser].DisplayName];
	[self.roomLabel setText:[GlobalVars getVar].memberedRoom.roomName];
	[self.tokenLabel setText:[NSString stringWithFormat:@"%d", [[RiverAuthController sharedAuth] currentUser].Tokens]];
	
}

- (void)fetchArtistDetails {
	[RiverAuthController authorizedSPQuery:kSPArtists
									action:kSPAlbums
									   _id:artistId
									  verb:kRiverGet
								withParams:nil
								  callback:^(NSDictionary *object, NSError *err) {
									  
									  if (!err) {
										  
										  self.albums = [object objectForKey:@"items"];
										  self.albumReleaseDates = [@[] mutableCopy];
										  
										  for (int i = 0; i < self.albums.count; i++) {
											  NSDictionary *album = [self.albums objectAtIndex:i];
											  
											  [RiverAuthController authorizedSPQuery:kSPAlbums
																			  action:nil
																				 _id:[album objectForKey:@"id"]
																				verb:kRiverGet
																		  withParams:nil
																			callback:^(NSDictionary *object, NSError *err) {
																				
																				if (!err) {
																					
																					ResultsAlbumTableViewCell *cell = (ResultsAlbumTableViewCell*)[albumsTVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
																					cell.releasedLabel.text = [[object objectForKey:@"release_date"] substringToIndex:4];
																				}
																			}];
										  }
										  
										  [self prepareLabels];
										  
										  [albumsTVC.tableView reloadData];
									  }
									  
									  [SVProgressHUD dismiss];
								  }];
}

- (IBAction)backPressed:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embedArtistAlbums"]) {
		albumsTVC = segue.destinationViewController;
	} else if ([segue.identifier isEqualToString:@"albumDetailSegue"]) {
		[(AlbumDetailViewController*)segue.destinationViewController setAlbumId:[[_albums objectAtIndex:[(NSIndexPath*)sender row]] objectForKey:@"id"]];
	}
}


@end
