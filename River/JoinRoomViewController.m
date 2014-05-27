//
//  JoinRoomViewController.m
//  River
//
//  Created by Matthew Gardner on 2/22/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "JoinRoomViewController.h"
#import "SWRevealViewController.h"
#import "RiverLoadingUtility.h"
#import "GlobalVars.h"

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
    
}

- (void)viewDidAppear:(BOOL)animated {
	[_roomField becomeFirstResponder];
	
	[super viewDidAppear:animated];
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
	
	[[RiverLoadingUtility sharedLoader] startLoading:self.view withFrame:CGRectNull withBackground:YES];

	Room *room = [[Room alloc] initWithID:_roomField.text];
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
