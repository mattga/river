//
//  ArtistAlbumsTableViewController.m
//  River
//
//  Created by Matthew Gardner on 5/11/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "ArtistAlbumsTableViewController.h"
#import "ResultsAlbumTableViewCell.h"
#import "RiverAuthAccount.h"
#import "AlbumDetailViewController.h"

@interface ArtistAlbumsTableViewController ()

@end

@implementation ArtistAlbumsTableViewController
@synthesize albums;

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
    return albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"artistAlbumCell"];
	
	[[(ResultsAlbumTableViewCell*)cell albumLabel] setText:[[albums objectAtIndex:indexPath.row] objectForKey:@"album_name"]];
	[[(ResultsAlbumTableViewCell*)cell releasedLabel] setText:[[albums objectAtIndex:indexPath.row] objectForKey:@"album_released"]];
	[[(ResultsAlbumTableViewCell*)cell albumArtImage] setImage:nil];
	
	dispatch_queue_t thread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(thread, ^{
		NSString *url= [RiverAuthAccount fetchAlbumArtForURL:[[albums objectAtIndex:indexPath.row] objectForKey:@"album_href"]];
		dispatch_async(dispatch_get_main_queue(), ^{
			UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			if (cell) {
				[[(ResultsAlbumTableViewCell*)cell albumArtImage] setImageWithURL:[NSURL URLWithString:url]];
			}
		});
	});
	
	return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 55.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.parentViewController performSegueWithIdentifier:@"albumDetailSegue" sender:indexPath];
}

@end
