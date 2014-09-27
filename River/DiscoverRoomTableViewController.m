//
//  DiscoverRoomTableViewController.m
//  River
//
//  Created by Matthew Gardner on 4/27/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "DiscoverRoomTableViewController.h"
#import "SVProgressHUD.h"
#import "RiverAlertUtility.h"
#import "RiverSyncUtility.h"

@interface DiscoverRoomTableViewController ()

@end

@implementation DiscoverRoomTableViewController
@synthesize rooms;
@synthesize selectedRoom;

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
    
    // Initialize
	selectedRoom = -1;
	
	// Configure pull to reload rooms
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    self.refreshControl = refresh;
}

- (void)viewDidAppear:(BOOL)animated {
	
	[SVProgressHUD show];
	
	[self reloadRooms];
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadRooms {

	[RiverAuthController authorizedRESTCall:kRiverWebApiRoom
								  action:nil
									verb:kRiverGet
									 _id:nil
							  withParams:nil
								callback:^(NSArray *objects, NSError *err) {
									rooms = [[NSMutableArray alloc] init];
									
									if (!err) {
										for (unsigned int i = 0; i < objects.count; i++) {
											NSDictionary *room = [objects objectAtIndex:i];
											Room *r = [[Room alloc] init];
											[r readFromJSONObject:room];
											[rooms addObject:r];
											
											if ([r.roomName isEqualToString:[GlobalVars getVar].memberedRoom.roomName]) {
												selectedRoom = i;
											}
										}
										
										[self.tableView reloadData];
									}
									
									[SVProgressHUD dismiss];
								}];
}

- (void)startRefresh {
	[self reloadRooms];
	
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:0.5];
}

- (void)stopRefresh {
    [self.refreshControl endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger roomCount = [rooms count];
    return roomCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *simpleTableIdentifier = @"discoverRoomCell";
	
    DiscoverRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    cell.roomLabel.text = [(Room*)[rooms objectAtIndex:indexPath.row] roomName];
    if (indexPath.row == selectedRoom || ([GlobalVars getVar].memberedRoom != nil && [cell.roomLabel.text isEqualToString:[GlobalVars getVar].memberedRoom.roomName]))
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
	if (selectedRoom == indexPath.row) {
		[cell setUserInteractionEnabled:NO];
	}
	
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 45.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[SVProgressHUD show];
	
    if (selectedRoom > -1 && selectedRoom != indexPath.row	) {
		// Update cells
		NSIndexPath *oldRow = [NSIndexPath indexPathForRow:selectedRoom inSection:0];
		selectedRoom = indexPath.row;
		NSIndexPath *newRow = [NSIndexPath indexPathForRow:selectedRoom inSection:0];
		[tableView reloadRowsAtIndexPaths:@[oldRow, newRow] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	
    Room *room = [rooms objectAtIndex:indexPath.row];
	
	[RiverAuthController authorizedRESTCall:kRiverWebApiRoom
								  action:kRiverActionJoinRoom
									verb:kRiverPost
									 _id:room.roomName
							  withParams:@{@"Username" : [RiverAuthController sharedAuth].currentUser.DisplayName}
								callback:^(NSDictionary *object, NSError *err) {
									
									if (!err) {
										RiverStatus *status = [[RiverStatus alloc] init];
										[status readFromJSONObject:object];
										
										if(status.statusCode.intValue == kRiverStatusOK ||
										   status.statusCode.intValue == kRiverStatusAlreadyExists) {
											
											[GlobalVars getVar].memberedRoom = room;
											[GlobalVars getVar].playingIndex = -1;
											
											[[RiverSyncUtility sharedSyncing] preemptRoomSync];
										} else {
											[RiverAlertUtility showOKAlertWithMessage:@"Error"];
										}
									}
									else {
										[RiverAlertUtility showOKAlertWithMessage:[err localizedDescription]];
									}
									
									[SVProgressHUD dismiss];
								}];
}



@end
