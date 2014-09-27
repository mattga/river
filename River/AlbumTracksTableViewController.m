//
//  AlbumTracksTableViewController.m
//  River
//
//  Created by Matthew Gardner on 5/12/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "AlbumTracksTableViewController.h"
#import "AlbumDetailViewController.h"
#import "ResultsSongTableViewCell.h"
#import "TrackDetailViewController.h"

@interface AlbumTracksTableViewController ()

@end

@implementation AlbumTracksTableViewController

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
    return [(AlbumDetailViewController*)self.parentViewController tracks].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumTrackCell"];
	
	NSDictionary *track = [[(AlbumDetailViewController*)self.parentViewController tracks] objectAtIndex:indexPath.row];
	
	[[(ResultsSongTableViewCell*)cell trackNumberLabel] setText:[NSString stringWithFormat:@"%d", [[track objectForKey:@"track_number"] intValue]]];
	[[(ResultsSongTableViewCell*)cell songLabel] setText:[track objectForKey:@"name"]];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.parentViewController performSegueWithIdentifier:@"trackDetailSegue" sender:indexPath];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40.0f;
}

@end
