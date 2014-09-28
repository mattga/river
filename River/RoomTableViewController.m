//
//  RoomTableViewController.m
//  River
//
//  Created by Matthew Gardner on 4/27/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RoomTableViewController.h"
#import "RiverAuthController.h"
#import "RiverViewController.h"

@interface RoomTableViewController ()

@end

@implementation RoomTableViewController

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
    
	memberedRoom = [GlobalVars getVar].memberedRoom;
	
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
    // Register KVO on synchronizer background thread
    appDelegate = (RiverAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self addObserver:self forKeyPath:@"appDelegate.syncId" options:0 context:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"appDelegate.syncId"]) {
		
		@synchronized([GlobalVars getVar].memberedRoom) {
			
			[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
			[(RoomViewController*)self.parentViewController performSelectorOnMainThread:@selector(reloadRoomData) withObject:nil waitUntilDone:NO];
			[(RiverViewController*)self.parentViewController performSelectorOnMainThread:@selector(updateFooter) withObject:nil waitUntilDone:NO];
		
		}
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"appDelegate.syncId"];
}


#pragma mark -
#pragma mark Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	memberedRoom = [GlobalVars getVar].memberedRoom;
	
    if(memberedRoom != nil) {
		if ([GlobalVars getVar].playingIndex > -1)
			return [memberedRoom.songs count]-1;
		else
			return [memberedRoom.songs count];
	}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int playingIndex = [GlobalVars getVar].playingIndex;
	
	NSString *cellId = @"songCell";
	RoomSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	Song *song = nil;
	
	if (memberedRoom != nil) {
		if (playingIndex > -1) {
			if (indexPath.row < playingIndex)
				song = [memberedRoom.songs objectAtIndex:indexPath.row];
			else
				song = [memberedRoom.songs objectAtIndex:indexPath.row+1];
		} else {
			song = [memberedRoom.songs objectAtIndex:indexPath.row];
		}
	}
	
	[cell setSong:song];
	
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int playingIndex = [GlobalVars getVar].playingIndex;

	if (playingIndex > -1) {
		if (indexPath.row < playingIndex)
			selectedTrack = [memberedRoom.songs objectAtIndex:indexPath.row];
		else
			selectedTrack = [memberedRoom.songs objectAtIndex:indexPath.row+1];
	} else {
		selectedTrack  = [memberedRoom.songs objectAtIndex:indexPath.row];
	}
		
	bidAlert = [RiverAlertUtility showInputAlertWithMessage:@"How many tokens would you like to add to this track?"
													 onView:self.parentViewController.view
													 params:@{@"keyboardType" : @((int)UIKeyboardTypeNumberPad),
															  @"initialValue" : @"0"}
												   okTarget:self
												   okAction:@selector(makeBid:)];
}

- (void)makeBid:(UIButton*)button {
	int bid = [bidAlert.inputField.text intValue];
	
	if (bid > 0) {
		
		[RiverAuthController authorizedRESTCall:kRiverWebApiRoom
									  action:kRiverActionAddSong
										verb:kRiverPost
										 _id:@"1"
								  withParams:@{@"RoomName" : memberedRoom.roomName,
											   @"Users" : @[@{@"User" : @{@"Username" : [RiverAuthController sharedAuth].currentUser.DisplayName}}],
											   @"Songs" : @[@{@"ProviderId" : selectedTrack.trackId,
															  @"Tokens" : @((int)bid)}]}
									callback:^(NSDictionary *object, NSError *err) {
										
										if (!err) {
											
											RiverStatus *status = [[RiverStatus alloc] init];
											[status readFromJSONObject:object];
											
											if(status.statusCode.intValue == kRiverStatusAlreadyExists) {
												
												NSLog(@"%d tokens added to %@", bid, selectedTrack.trackId);
												
												[bidAlert removeFromSuperview];
												
												[RiverAlertUtility showOKAlertWithMessage:[NSString stringWithFormat:@"%d tokens added to %@", bid, selectedTrack.title]];
												
												[self.navigationController popToRootViewControllerAnimated:YES];
											} else {
												
												[RiverAlertUtility showOKAlertWithMessage:@"ERROR"];
											}
											
											[bidAlert removeFromSuperview];
										}
									}];
    } else {
		[bidAlert removeFromSuperview];
	}
}

@end
