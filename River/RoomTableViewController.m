//
//  RoomTableViewController.m
//  River
//
//  Created by Matthew Gardner on 4/27/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RoomTableViewController.h"
#import "RiverAuthAccount.h"

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
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
		[(RoomViewController*)self.parentViewController performSelectorOnMainThread:@selector(reloadRoomData) withObject:nil waitUntilDone:NO];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"appDelegate.syncId"];
}


#pragma mark -
#pragma mark Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
	Track *song = nil;
	
	if (memberedRoom != nil) {
		if (playingIndex > -1) {
			if (indexPath.row < playingIndex)
				song = [memberedRoom.songs objectAtIndex:indexPath.row];
			else
				song = [memberedRoom.songs objectAtIndex:indexPath.row+1];
		} else {
			song =[memberedRoom.songs objectAtIndex:indexPath.row];
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

	selectedTrack = [memberedRoom.songs objectAtIndex:indexPath.row];
	
	bidAlert = [RiverAlertUtility showInputAlertWithMessage:@"How many tokens would you like to add to this track?"
										  params:@{@"keyboardType" : @((int)UIKeyboardTypeNumberPad),
												   @"initialValue" : @"0"}
										okTarget:self
										okAction:@selector(makeBid:)];
}

- (void)makeBid:(UIButton*)button {
	int bid = [bidAlert.inputField.text intValue];
	
	if (bid > 0) {
		
		[RiverAuthAccount authorizedRESTCall:kRiverRESTAddSong withParams:@{@"groupId" : memberedRoom.roomID,
																			@"userId" : [RiverAuthAccount sharedAuth].userId,
																			@"songId" : selectedTrack.trackId,
																			@"title" : selectedTrack.title,
																			@"artist" : selectedTrack.artist,
																			@"points" : @((int)bid)}
									callback:^(NSData *response, NSError *err) {
										if (!err) {
											NSString *responseText = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
											if([responseText isEqualToString:[NSString stringWithFormat:@"Success adding points to song %@", selectedTrack.trackId]]) {
												
												NSLog(@"%d tokens added to %@", bid, selectedTrack.trackId);
												
												[bidAlert removeFromSuperview];
												
												[RiverAlertUtility showOKAlertWithMessage:[NSString stringWithFormat:@"%d tokens added to %@", bid, selectedTrack.title]];
											} else {
												
												[RiverAlertUtility showErrorWithMessage:responseText];
											}
										}
									}];
    } else {
		[bidAlert removeFromSuperview];
	}
}

@end
