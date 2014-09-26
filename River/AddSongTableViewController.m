		//
//  AddSongTableViewController.m
//  River
//
//  Created by Matthew Gardner on 5/8/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "AddSongTableViewController.h"
#import "RiverAuthController.h"
#import "AddSongViewController.h"
#import "SPJSONParser.h"

@interface AddSongTableViewController ()

@end

@implementation AddSongTableViewController
@synthesize selectedTab, selectedRow;

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
			return [(AddSongViewController*)self.parentViewController trackResults].count;
		case kSearchResultsArtists:
			return [(AddSongViewController*)self.parentViewController artistResults].count;
		case kSearchResultsAlbums:
			return [(AddSongViewController*)self.parentViewController albumResults].count;
	}
	return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	NSDictionary *dict;
	
	if (selectedTab == kSearchResultsSongs) {
		
		cell = [tableView dequeueReusableCellWithIdentifier:@"resultsSongCell"];
		dict = [[(AddSongViewController*)self.parentViewController trackResults] objectAtIndex:indexPath.row];
		
		[(ResultsSongTableViewCell*)cell songLabel].text = [dict objectForKey:@"name"];
		[(ResultsSongTableViewCell*)cell artistLabel].text = [[[dict objectForKey:@"artists"] firstObject] objectForKey:@"name"];
		[[(ResultsSongTableViewCell*)cell albumArtImage] setImage:nil];
		
		dispatch_queue_t thread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		dispatch_async(thread, ^{
			NSURL *url = [SPJSONParser imageURLFromSPJSON:[dict objectForKey:@"album"] withSize:kRiverAlbumArtSmall];
			dispatch_async(dispatch_get_main_queue(), ^{
				UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
				if (cell) {
					[[(ResultsSongTableViewCell*)cell albumArtImage] setImageWithURL:url];
				}
			});
		});
	} else if (selectedTab == kSearchResultsArtists) {
		
		cell = [tableView dequeueReusableCellWithIdentifier:@"resultsArtistCell"];
		dict = [[(AddSongViewController*)self.parentViewController artistResults] objectAtIndex:indexPath.row];
		
		[(ResultsArtistTableViewCell*)cell artistLabel].text = [dict objectForKey:@"name"];
		[[(ResultsArtistTableViewCell*)cell artistSPImage] setImage:nil];
		
		dispatch_queue_t thread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		dispatch_async(thread, ^{
			NSURL *url= [SPJSONParser imageURLFromSPJSON:dict withSize:60];
			dispatch_async(dispatch_get_main_queue(), ^{
				UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
				if (cell) {
					[[(ResultsArtistTableViewCell*)cell artistSPImage] setImageWithURL:url];
				}
			});
		});
	} else if (selectedTab == kSearchResultsAlbums) {
		
		cell = [tableView dequeueReusableCellWithIdentifier:@"resultsAlbumCell"];
		dict = [[(AddSongViewController*)self.parentViewController albumResults] objectAtIndex:indexPath.row];
		
		[(ResultsAlbumTableViewCell*)cell albumLabel].text = [dict objectForKey:@"name"];
		[[(ResultsSongTableViewCell*)cell albumArtImage] setImage:nil];
		
		dispatch_queue_t thread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		dispatch_async(thread, ^{
			NSURL *url= [SPJSONParser imageURLFromSPJSON:dict withSize:60];
			dispatch_async(dispatch_get_main_queue(), ^{
				UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
				if (cell) {
					[[(ResultsSongTableViewCell*)cell albumArtImage] setImageWithURL:url];
				}
			});
		});
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
			return 50.0f;
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
