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

@interface AddSongViewController ()
@end

@implementation AddSongViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchSpotify:(NSString *)searchText {
	[RiverAuthAccount authorizedRESTCall:kSPSearchTracks withParams:@{@"query" : searchText} callback:^(NSData *response, NSError *err) {
		SPTracksXMLParser *parser = [[SPTracksXMLParser alloc] initWithData:response outputArray:trackResults];
		[parser setDelegate:parser];
		if (![parser parse])
			NSLog(@"AddSongViewController::searchSPTracks() - ERROR: %@", [[parser parserError] description]);
		
		if (resultsTVC.selectedTab == kSearchResultsSongs)
			[resultsTVC.tableView reloadData];
		
		tracksFetched = YES;
		if (tracksFetched && artistsFetched && albumsFetched) {
			[[RiverLoadingUtility sharedLoader] stopLoading];
		}
	}];
	
	[RiverAuthAccount authorizedRESTCall:kSPSearchArtists withParams:@{@"query" : searchText} callback:^(NSData *response, NSError *err) {
		SPArtistsXMLParser *parser = [[SPArtistsXMLParser alloc] initWithData:response outputArray:artistResults];
		[parser setDelegate:parser];
		if (![parser parse])
			NSLog(@"AddSongViewController::searchSPArtists() - ERROR: %@", [[parser parserError] description]);
		
		if (resultsTVC.selectedTab == kSearchResultsArtists)
			[resultsTVC.tableView reloadData];
		
		artistsFetched = YES;
		if (tracksFetched && artistsFetched && albumsFetched) {
			[[RiverLoadingUtility sharedLoader] stopLoading];
		}
	}];
	
	[RiverAuthAccount authorizedRESTCall:kSPSearchAlbums withParams:@{@"query" : searchText} callback:^(NSData *response, NSError *err) {
		SPAlbumsXMLParser *parser = [[SPAlbumsXMLParser alloc] initWithData:response outputArray:albumResults];
		[parser setDelegate:parser];
		if (![parser parse])
			NSLog(@"AddSongViewController::searchSPAlbums() - ERROR: %@", [[parser parserError] description]);
		
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
	[self.songsLabel setTextColor:kRiverBGLightGray];
	[self.artistsButton setBackgroundColor:kRiverBGLightGray];
	[self.artistsLabel setTextColor:kRiverLightBlue];
	[self.albumsButton setBackgroundColor:kRiverBGLightGray];
	[self.albumsLabel setTextColor:kRiverLightBlue];
	
	[resultsTVC setSelectedTab:kSearchResultsSongs];
	
	[resultsTVC.tableView reloadData];
}

- (IBAction)artistsPressed:(id)sender {
	[self.songsButton setBackgroundColor:kRiverBGLightGray];
	[self.songsLabel setTextColor:kRiverLightBlue];
	[self.artistsButton setBackgroundColor:kRiverLightBlue];
	[self.artistsLabel setTextColor:kRiverBGLightGray];
	[self.albumsButton setBackgroundColor:kRiverBGLightGray];
	[self.albumsLabel setTextColor:kRiverLightBlue];
	
	[resultsTVC setSelectedTab:kSearchResultsArtists];
	
	[resultsTVC.tableView reloadData];
}

- (IBAction)albumsPressed:(id)sender {
	[self.songsButton setBackgroundColor:kRiverBGLightGray];
	[self.songsLabel setTextColor:kRiverLightBlue];
	[self.artistsButton setBackgroundColor:kRiverBGLightGray];
	[self.artistsLabel setTextColor:kRiverLightBlue];
	[self.albumsButton setBackgroundColor:kRiverLightBlue];
	[self.albumsLabel setTextColor:kRiverBGLightGray];
	
	[resultsTVC setSelectedTab:kSearchResultsAlbums];
	
	[resultsTVC.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embedResultsTable"]) {
		resultsTVC = segue.destinationViewController;
		
		// Initialize result arrays
		albumResults = [[NSMutableArray alloc] init];
		artistResults = [[NSMutableArray alloc] init];
		trackResults = [[NSMutableArray alloc] init];
		
        [resultsTVC setTrackResults:trackResults];
        [resultsTVC setArtistResults:artistResults];
        [resultsTVC setAlbumResults:albumResults];
	} else if ([segue.identifier isEqualToString:@"trackDetailSegue"]) {
		[(TrackDetailViewController*)segue.destinationViewController setTrack:[trackResults objectAtIndex:resultsTVC.selectedRow]];
	} else if ([segue.identifier isEqualToString:@"artistDetailSegue"]) {
		[(ArtistDetailViewController*)segue.destinationViewController setArtist:[artistResults objectAtIndex:resultsTVC.selectedRow]];
	} else if ([segue.identifier isEqualToString:@"albumDetailSegue"]) {
		[(AlbumDetailViewController*)segue.destinationViewController setAlbum:[albumResults objectAtIndex:resultsTVC.selectedRow]];
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
										   withFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 100)
									  withBackground:YES];
	
	[textField resignFirstResponder];
	
    [self searchSpotify:self.searchField.text];
	
    [resultsTVC.tableView reloadData];
	
    return YES;
}


@end