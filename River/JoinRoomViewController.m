//
//  JoinRoomViewController.m
//  River
//
//  Created by Matthew Gardner on 2/22/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "JoinRoomViewController.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "RiverLoadingUtility.h"
#import "GlobalVars.h"
#import "RiverSyncUtility.h"

@interface JoinRoomViewController ()

@end

@implementation JoinRoomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:_roomField action:@selector(resignFirstResponder)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)regainFirstResponder {
	[_roomField becomeFirstResponder];
}

- (IBAction)joinPressed:(id)sender {
	
	[[RiverLoadingUtility sharedLoader] startLoading:self.view withFrame:CGRectNull];

	Room *room = [[Room alloc] initWithName:_roomField.text];

	[RiverAuthAccount authorizedRESTCall:kRiverRESTRoom
								  action:kRiverActionJoinRoom
									verb:kRiverPost
									 _id:room.roomName
							  withParams:@{@"Username" : [RiverAuthAccount sharedAuth].username}
								callback:^(NSDictionary *object, NSError *err) {
									
									if (!err) {
										RiverStatus *status = [[RiverStatus alloc] init];
										[status readFromJSONObject:object];
										
										if (status.statusCode.intValue == kRiverStatusOK) {
											
											[GlobalVars getVar].memberedRoom = room;
											[GlobalVars getVar].playingIndex = -1;
											
											[[RiverSyncUtility sharedSyncing] preemptRoomSync];
											
											SideMenuViewController *sideMenuVC = (SideMenuViewController*)((SWRevealViewController*)[(RiverViewController*)self revealViewController]).rearViewController;
											[[sideMenuVC tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:kSideMenuShare inSection:0]
																				animated:NO
																		  scrollPosition:UITableViewScrollPositionNone];
											[self.revealViewController.rearViewController performSegueWithIdentifier:@"roomSegue" sender:nil];
										} else if (status.statusCode.intValue == kRiverStatusNotFound) {
											[RiverAlertUtility showOKAlertWithMessage:@"Room does not exist!"
																			   onView:self.view];
										} else {
											[RiverAlertUtility showOKAlertWithMessage:@"ERROR"
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

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[_roomField resignFirstResponder];
	
	return YES;
}


@end
