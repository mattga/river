//
//  DiscoverRoomTableViewController.m
//  River
//
//  Created by Matthew Gardner on 4/27/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "DiscoverRoomTableViewController.h"
#import "RiverLoadingUtility.h"
#import "RiverAlertUtility.h"

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
	
	[[RiverLoadingUtility sharedLoader] startLoading:self.view withFrame:CGRectNull withBackground:YES];
	
	[self reloadRooms];
	[super viewDidAppear:animated];
	
	[[RiverLoadingUtility sharedLoader] stopLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadRooms {
	
    NSString *requestString = [NSString stringWithFormat:@"%@://%@/list", kRiverWebProtocol, kRiverWebHost];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
	[request setHTTPMethod:@"GET"];
	
	RiverConnection *connection = [[RiverConnection alloc] initWithRequest:request];
	[connection setCompletionBlock:^(NSData *response, NSError *err) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		NSArray *jsonObj = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
		
		NSString *room;
		for (int i = 0; i < [jsonObj count]; i++) {
			room = [[jsonObj objectAtIndex:i] objectForKey:@"groupId"];
			if ([room isEqualToString:[GlobalVars getVar].memberedRoom.roomID])
				selectedRoom = i;
			[array addObject:room];
		}
		
		rooms = array;
		[self.tableView reloadData];
	}];
	
	[connection start];
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
    
    cell.roomLabel.text = [rooms objectAtIndex:indexPath.row];
    if (indexPath.row == selectedRoom || ([GlobalVars getVar].memberedRoom != nil && [cell.roomLabel.text isEqualToString:[GlobalVars getVar].memberedRoom.roomID]))
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 49.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[[RiverLoadingUtility sharedLoader] startLoading:self.view withFrame:CGRectNull withBackground:YES];
	
    if (selectedRoom > -1 && selectedRoom != indexPath.row	) {
		// Update cells
		NSIndexPath *oldRow = [NSIndexPath indexPathForRow:selectedRoom inSection:0];
		selectedRoom = indexPath.row;
		NSIndexPath *newRow = [NSIndexPath indexPathForRow:selectedRoom inSection:0];
		[tableView reloadRowsAtIndexPaths:@[oldRow, newRow] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	
    Room *room = [[Room alloc] initWithID:[rooms objectAtIndex:indexPath.row]];
    [GlobalVars getVar].memberedRoom = room;
    
	[RiverAuthAccount authorizedRESTCall:kRiverRESTJoinGroup withParams:@{@"groupId" : room.roomID, @"userId" : [[RiverAuthAccount sharedAuth] userId]} callback:^(NSData *response, NSError *err) {
		if (!err) {
			NSString *responseText = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
			if([responseText isEqualToString:[NSString stringWithFormat:@"Success adding userId %@", [GlobalVars getVar].username]] ||
			   [responseText isEqualToString:[NSString stringWithFormat:@"Success User already exists"]]) {
				
//				[RiverAlertUtility showOKAlertWithMessage:[NSString stringWithFormat:@"You have just joined the room %@!", room.roomID]];
				
				[self performSegueWithIdentifier:@"goHome" sender:self];
			} else {
				[RiverAlertUtility showOKAlertWithMessage:responseText];
			}
		}
		else {
			[RiverAlertUtility showOKAlertWithMessage:[err localizedDescription]];
		}
		
		[[RiverLoadingUtility sharedLoader] stopLoading];
	}];
}



@end
