		//
//  AddSongTableViewController.m
//  River
//
//  Created by Matthew Gardner on 5/8/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "AddSongTableViewController.h"

@interface AddSongTableViewController ()

@end

@implementation AddSongTableViewController
@synthesize selectedTab, selectedRow;
@synthesize trackResults, artistResults, albumResults;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (selectedTab) {
		case kSearchResultsSongs:
			return trackResults.count;
		case kSearchResultsArtists:
			return artistResults.count;
		case kSearchResultsAlbums:
			return albumResults.count;
	}
	return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	NSDictionary *dict;
	
	switch (selectedTab) {
		case kSearchResultsSongs:
			cell = [tableView dequeueReusableCellWithIdentifier:@"resultsSongCell"];
			dict = [trackResults objectAtIndex:indexPath.row];
			
			[(ResultsSongTableViewCell*)cell songLabel].text = [dict objectForKey:@"track_name"];
			[(ResultsSongTableViewCell*)cell artistLabel].text = [dict objectForKey:@"artist_name"];
			
			break;
		case kSearchResultsArtists:
			cell = [tableView dequeueReusableCellWithIdentifier:@"resultsArtistCell"];
			dict = [artistResults objectAtIndex:indexPath.row];
			
			[(ResultsArtistTableViewCell*)cell artistLabel].text = [dict objectForKey:@"artist_name"];
			
			break;
		case kSearchResultsAlbums:
			cell = [tableView dequeueReusableCellWithIdentifier:@"resultsAlbumCell"];
			dict = [albumResults objectAtIndex:indexPath.row];
			
			[(ResultsAlbumTableViewCell*)cell albumLabel].text = [dict objectForKey:@"album_name"];
			[(ResultsAlbumTableViewCell*)cell artistLabel].text = [dict objectForKey:@"artist_name"];
			
			break;
	}
	
	return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (selectedTab) {
		case kSearchResultsSongs:
			return 60.0f;
		case kSearchResultsArtists:
			return 50.0f;
		case kSearchResultsAlbums:
			return 60.0f;
	}
	return 20.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	selectedRow = indexPath.row;
	
	switch (selectedTab) {
		case kSearchResultsSongs:
			[self.parentViewController performSegueWithIdentifier:@"trackDetailSegue" sender:nil];
			break;
		case kSearchResultsArtists:
			[self.parentViewController performSegueWithIdentifier:@"artistDetailSegue" sender:nil];
			break;
		case kSearchResultsAlbums:
			[self.parentViewController performSegueWithIdentifier:@"albumDetailSegue" sender:nil];
			break;
	}
}

@end
