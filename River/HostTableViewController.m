//
//  HostViewTableViewController.m
//  River
//
//  Created by Matthew Gardner on 5/5/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "HostTableViewController.h"
#import "GlobalVars.h"

@interface HostTableViewController ()

@end

@implementation HostTableViewController
@synthesize selectedTab;
@synthesize songs, members;

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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (selectedTab) {
		case kHostSongsSelected:
			return [GlobalVars getVar].memberedRoom.songs.count;
		case kHostMembersSelected:
			return [GlobalVars getVar].memberedRoom.members.count;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	switch (selectedTab) {
		case kHostSongsSelected:
			cell = [tableView dequeueReusableCellWithIdentifier:@"songCell"];
			[(RoomSongTableViewCell*)cell setSong:[[GlobalVars getVar].memberedRoom.songs objectAtIndex:indexPath.row]];
			
			break;
		case kHostMembersSelected:
			cell = [tableView dequeueReusableCellWithIdentifier:@"memberCell"];
			[(RoomMemberTableViewCell*)cell setMember:[[GlobalVars getVar].memberedRoom.members objectAtIndex:indexPath.row]];
			
			break;
	}
	
	return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (selectedTab) {
		case kHostSongsSelected:
			return 60;
		case kHostMembersSelected:
			return 50;
	}
	return 40;
}

@end
