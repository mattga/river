//
//  MainViewController.m
//  CollabStream
//
//  Created by Matthew Gardner on 1/22/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "AddSongViewController.h"
#import "CocoaLibSpotify.h"
#import "GlobalVars.h"
#import "TrackDetailViewController.h"
#import "ArtistDetailViewController.h"
#import "AlbumDetailViewController.h"
#import "SVProgressHUD.h"
#import "SPJSONParser.h"


@implementation AddSongViewController
@synthesize trackResults, albumResults, artistResults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
								   initWithTarget:self.view
								   action:@selector(endEditing:)];
	[tap setDelegate:self];
	[self.view addGestureRecognizer:tap];
	
	NSString *searchKeyword = [GlobalVars getVar].searchKeyword;
	if (searchKeyword != nil && ![searchKeyword isEqualToString:@""]) {
		
		self.searchBar.text = searchKeyword;
		[self searchSpotify:searchKeyword];
		
		[resultsTVC.tableView reloadData];
	}
	
	self.songsButton.layer.cornerRadius = 20;
	[self.songsButton setTitleColor:kRiverDarkGray forState:UIControlStateNormal];
	[self.songsButton setTitleColor:kRiverWhite forState:UIControlStateSelected];
	
	self.albumsButton.layer.cornerRadius = 20;
	[self.albumsButton setTitleColor:kRiverDarkGray forState:UIControlStateNormal];
	[self.albumsButton setTitleColor:kRiverWhite forState:UIControlStateSelected];
	
	self.artistsButton.layer.cornerRadius = 20;
	[self.artistsButton setTitleColor:kRiverDarkGray forState:UIControlStateNormal];
	[self.artistsButton setTitleColor:kRiverWhite forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self searchSpotify:searchBar.text];
}

- (void)searchSpotify:(NSString *)searchText {
	[RiverAuthController authorizedSPQuery:kSPSearch
									action:nil
									   _id:nil
									  verb:kRiverGet
								withParams:@{@"q" : searchText, @"type" : @"track"}
								  callback:^(NSDictionary *object, NSError *err) {
									  trackResults = [SPJSONParser tracksFromSPJSON:object];
									  
									  if (resultsTVC.selectedTab == kSearchResultsSongs)
										  [resultsTVC.tableView reloadData];
									  
									  tracksFetched = YES;
									  if (tracksFetched && artistsFetched && albumsFetched) {
										  [SVProgressHUD dismiss];
									  }
								  }];
	
	[RiverAuthController authorizedSPQuery:kSPSearch
									action:nil
									   _id:nil
									  verb:kRiverGet
								withParams:@{@"q" : searchText, @"type" : @"artist"}
								  callback:^(NSDictionary *object, NSError *err) {
									  artistResults = [SPJSONParser artistsFromSPJSON:object];
									  
									  if (resultsTVC.selectedTab == kSearchResultsArtists)
										  [resultsTVC.tableView reloadData];
									  
									  artistsFetched = YES;
									  if (tracksFetched && artistsFetched && albumsFetched) {
										  [SVProgressHUD dismiss];
									  }
								  }];
	
	[RiverAuthController authorizedSPQuery:kSPSearch
									action:nil
									   _id:nil
									  verb:kRiverGet
								withParams:@{@"q" : searchText, @"type" : @"album"}
								  callback:^(NSDictionary *object, NSError *err) {
									  albumResults = [SPJSONParser albumsFromSPJSON:object];
									  
									  if (resultsTVC.selectedTab == kSearchResultsAlbums)
										  [resultsTVC.tableView reloadData];
									  
									  albumsFetched = YES;
									  if (tracksFetched && artistsFetched && albumsFetched) {
										  [SVProgressHUD dismiss];
									  }
								  }];
}

- (IBAction)songsPressed:(id)sender {
	
	self.songsButton.selected = YES;
	self.artistsButton.selected = NO;
	self.albumsButton.selected = NO;
	[self.songsButton setBackgroundColor:kRiverDarkGray];
	[self.artistsButton setBackgroundColor:kRiverWhite];
	[self.albumsButton setBackgroundColor:kRiverWhite];
	
	[resultsTVC setSelectedTab:kSearchResultsSongs];
	
	[resultsTVC.tableView reloadData];
}

- (IBAction)artistsPressed:(id)sender {
	
	self.songsButton.selected = NO;
	self.artistsButton.selected = YES;
	self.albumsButton.selected = NO;
	[self.songsButton setBackgroundColor:kRiverWhite];
	[self.artistsButton setBackgroundColor:kRiverDarkGray];
	[self.albumsButton setBackgroundColor:kRiverWhite];
	
	[resultsTVC setSelectedTab:kSearchResultsArtists];
	
	[resultsTVC.tableView reloadData];
}

- (IBAction)albumsPressed:(id)sender {
	
	self.songsButton.selected = NO;
	self.artistsButton.selected = NO;
	self.albumsButton.selected = YES;
	[self.songsButton setBackgroundColor:kRiverWhite];
	[self.artistsButton setBackgroundColor:kRiverWhite];
	[self.albumsButton setBackgroundColor:kRiverDarkGray];
	
	[resultsTVC setSelectedTab:kSearchResultsAlbums];
	
	[resultsTVC.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embedResultsTable"]) {
		resultsTVC = segue.destinationViewController;
	} else if ([segue.identifier isEqualToString:@"trackDetailSegue"]) {
		[(TrackDetailViewController*)segue.destinationViewController setTrack:[trackResults objectAtIndex:resultsTVC.selectedRow]];
	} else if ([segue.identifier isEqualToString:@"artistDetailSegue"]) {
		[(ArtistDetailViewController*)segue.destinationViewController setArtistId:[[artistResults objectAtIndex:resultsTVC.selectedRow] objectForKey:@"id"]];
		[(ArtistDetailViewController*)segue.destinationViewController setArtistName:[[artistResults objectAtIndex:resultsTVC.selectedRow] objectForKey:@"name"]];
	} else if ([segue.identifier isEqualToString:@"albumDetailSegue"]) {
		[(AlbumDetailViewController*)segue.destinationViewController setAlbumId:[[albumResults objectAtIndex:resultsTVC.selectedRow] objectForKey:@"id"]];
	}
}

#pragma mark - Gesture recognizer delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if ([self.searchBar isFirstResponder])
		return YES;
	return NO;
}

#pragma mark - Text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	[textField setSelectedTextRange:[textField textRangeFromPosition:textField.beginningOfDocument toPosition:textField.endOfDocument]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s]+" options:NSRegularExpressionCaseInsensitive error:nil];
	NSString *text = [regex stringByReplacingMatchesInString:textField.text options:0 range:NSMakeRange(0, textField.text.length) withTemplate:@""];
	
	if ([text isEqualToString:@""]) {
		[textField setText:@""];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[SVProgressHUD show];
	[textField resignFirstResponder];
	
	[GlobalVars getVar].searchKeyword = self.searchBar.text;
	[self searchSpotify:self.searchBar.text];
	
	[resultsTVC.tableView reloadData];
	
	return YES;
}


@end