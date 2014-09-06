//
//  CreateRoomViewController.m
//  River
//
//  Created by Matthew Gardner on 2/23/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "CreateRoomViewController.h"
#import "GlobalVars.h"
#import "RiverAuthAccount.h"
#import "User.h"
#import "RiverLoadingUtility.h"
#import "SideMenuViewController.h"
#import "SWRevealViewController.h"
#import "RiverSyncUtility.h"

#define SP_LIBSPOTIFY_DEBUG_LOGGING 1

@interface CreateRoomViewController ()

@end

@implementation CreateRoomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.usernameLabel.text = [RiverAuthAccount sharedAuth].username;
    self.roomLabel.text = ([GlobalVars getVar].memberedRoom==nil ? @"-" : [NSString stringWithFormat:@"%@",[GlobalVars getVar].memberedRoom]);
	
    // Register KVO on synchronizer background thread
    appDelegate = (RiverAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self addObserver:self forKeyPath:@"appDelegate.syncId" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"appDelegate.syncId"]) {
		[(RiverViewController*)self performSelectorOnMainThread:@selector(updateFooter) withObject:nil waitUntilDone:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"appDelegate.syncId"];
}

-(void)regainFirstResponder {
	[_roomField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return YES;
}

- (IBAction)createPressed:(id)sender {
	
	[[RiverLoadingUtility sharedLoader] startLoading:self.view withFrame:CGRectNull];
	
	[RiverAuthAccount authorizedRESTCall:kRiverRESTRoom
								  action:nil
									verb:kRiverPost
									 _id:nil
							  withParams:@{@"RoomName" : self.roomField.text,
										   @"Users" : @[@{@"User" : @{@"Username" : [RiverAuthAccount sharedAuth].username}}]}
								callback:^(NSDictionary *object, NSError *err) {
									
									if (!err) {
										Room *room = [[Room alloc] init];
										[room readFromJSONObject:object];
										
										if(room.statusCode.intValue == kRiverStatusOK) {
											
											[GlobalVars getVar].memberedRoom = room;
											[GlobalVars getVar].playingIndex = -1;
											
											[[RiverSyncUtility sharedSyncing] preemptRoomSync];
											
											SideMenuViewController *sideMenuVC = (SideMenuViewController*)((SWRevealViewController*)[(RiverViewController*)self revealViewController]).rearViewController;
											[[sideMenuVC tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:kSideMenuShare inSection:0]
																				animated:NO
																		  scrollPosition:UITableViewScrollPositionNone];
											[self.revealViewController.rearViewController performSegueWithIdentifier:@"roomSegue" sender:nil];
										} else if (room.statusCode.intValue == kRiverStatusAlreadyExists) {
											[RiverAlertUtility showOKAlertWithMessage:@"Room already exists."
																			   onView:self.view];
										} else {
											[RiverAlertUtility showOKAlertWithMessage:@"Error"
																			   onView:self.view];
										}
									}
									else {
										[RiverAlertUtility showOKAlertWithMessage:[err localizedDescription]
																		   onView:self.view];
									}
									
									[[RiverLoadingUtility sharedLoader] stopLoading];
								}];

}


@end
