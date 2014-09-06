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
#import "RiverLoadingUtility.h"
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
	
    // Register delegate for search field
    [self.searchField setDelegate:self];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
								   initWithTarget:self.view
								   action:@selector(endEditing:)];
	[tap setDelegate:self];
	[self.view addGestureRecognizer:tap];
	
	NSString *searchKeyword = [GlobalVars getVar].searchKeyword;
	if (searchKeyword != nil && ![searchKeyword isEqualToString:@""]) {

		self.searchField.text = searchKeyword;
		[self.searchPlaceholderLabel setHidden:YES];
		[self searchSpotify:searchKeyword];
		
		[resultsTVC.tableView reloadData];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchSpotify:(NSString *)searchText {
	[RiverAuthAccount authorizedRESTCall:kSPRESTSearch
								  action:nil
									verb:kRiverGet
									 _id:nil
							  withParams:@{@"q" : searchText, @"type" : @"track"}
								callback:^(NSDictionary *object, NSError *err) {
									trackResults = [SPJSONParser tracksFromSPJSON:object];
									
									if (resultsTVC.selectedTab == kSearchResultsSongs)
										[resultsTVC.tableView reloadData];
									
									tracksFetched = YES;
									if (tracksFetched && artistsFetched && albumsFetched) {
										[[RiverLoadingUtility sharedLoader] stopLoading];
									}
								}];
	
	[RiverAuthAccount authorizedRESTCall:kSPRESTSearch
								  action:nil
									verb:kRiverGet
									 _id:nil
							  withParams:@{@"q" : searchText, @"type" : @"artist"}
								callback:^(NSDictionary *object, NSError *err) {
									artistResults = [SPJSONParser artistsFromSPJSON:object];
									
									if (resultsTVC.selectedTab == kSearchResultsArtists)
										[resultsTVC.tableView reloadData];
									
									artistsFetched = YES;
									if (tracksFetched && artistsFetched && albumsFetched) {
										[[RiverLoadingUtility sharedLoader] stopLoading];
									}
								}];
	
	[RiverAuthAccount authorizedRESTCall:kSPRESTSearch
								  action:nil
									verb:kRiverGet
									 _id:nil
							  withParams:@{@"q" : searchText, @"type" : @"album"}
								callback:^(NSDictionary *object, NSError *err) {
									albumResults = [SPJSONParser albumsFromSPJSON:object];
									
									if (resultsTVC.selectedTab == kSearchResultsAlbums)
										[resultsTVC.tableView reloadData];
									
									albumsFetched = YES;
									if (tracksFetched && artistsFetched && albumsFetched) {
										[[RiverLoadingUtility sharedLoader] stopLoading];
									}
								}];
}

- (IBAction)songsPressed:(id)sender {
	
	[self.songsButton setBackgroundColor:kRiverLightBlue];
	[self.songsButton.titleLabel setTextColor:kRiverBGLightGray];
	[self.artistsButton setBackgroundColor:kRiverBGLightGray];
	[self.artistsButton.titleLabel setTextColor:kRiverLightBlue];
	[self.albumsButton setBackgroundColor:kRiverBGLightGray];
	[self.albumsButton.titleLabel setTextColor:kRiverLightBlue];
	
	[resultsTVC setSelectedTab:kSearchResultsSongs];
	
	[resultsTVC.tableView reloadData];
}

- (IBAction)artistsPressed:(id)sender {
	
	[self.songsButton setBackgroundColor:kRiverBGLightGray];
	[self.songsButton.titleLabel setTextColor:kRiverLightBlue];
	[self.artistsButton setBackgroundColor:kRiverLightBlue];
	[self.songsButton.titleLabel setTextColor:kRiverBGLightGray];
	[self.albumsButton setBackgroundColor:kRiverBGLightGray];
	[self.albumsButton.titleLabel setTextColor:kRiverLightBlue];
	
	[resultsTVC setSelectedTab:kSearchResultsArtists];
	
	[resultsTVC.tableView reloadData];
}

- (IBAction)albumsPressed:(id)sender {
	
	[self.songsButton setBackgroundColor:kRiverBGLightGray];
	[self.songsButton.titleLabel setTextColor:kRiverLightBlue];
	[self.artistsButton setBackgroundColor:kRiverBGLightGray];
	[self.artistsButton.titleLabel setTextColor:kRiverLightBlue];
	[self.albumsButton setBackgroundColor:kRiverLightBlue];
	[self.albumsButton.titleLabel setTextColor:kRiverBGLightGray];
	
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
	if ([self.searchField isFirstResponder])
		return YES;
	return NO;
}

#pragma mark - Text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[self.searchPlaceholderLabel setHidden:YES];
	
	[textField setSelectedTextRange:[textField textRangeFromPosition:textField.beginningOfDocument toPosition:textField.endOfDocument]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s]+" options:NSRegularExpressionCaseInsensitive error:nil];
	NSString *text = [regex stringByReplacingMatchesInString:textField.text options:0 range:NSMakeRange(0, textField.text.length) withTemplate:@""];
	
	if ([text isEqualToString:@""]) {
		[textField setText:@""];
		[self.searchPlaceholderLabel setHidden:NO];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[RiverLoadingUtility sharedLoader] startLoading:self.view
										   withFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 100)];
	
	[textField resignFirstResponder];
	
	[GlobalVars getVar].searchKeyword = self.searchField.text;
	[self searchSpotify:self.searchField.text];
	
	[resultsTVC.tableView reloadData];
	
	return YES;
}


@end