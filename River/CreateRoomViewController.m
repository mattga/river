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
    
}

- (void)viewDidAppear:(BOOL)animated {
	[_roomField becomeFirstResponder];
	
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)regainFirstResponder {
	[_roomField becomeFirstResponder];
}

- (IBAction)createPressed:(id)sender {
	
	User *user = [RiverAuthAccount sharedAuth].currentUser;
	
	[RiverAuthAccount authorizedRESTCall:kRiverRESTNewGroup withParams:@{@"groupId" : _roomField.text, @"userId" : user.userId} callback:^(NSData *response, NSError *err){
		if (!err) {
			NSString *responseText = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
			
			if([responseText isEqualToString:[NSString stringWithFormat:@"Success creating new group %@!", _roomField.text]]) {
				//Create room object to store globally & dismiss UI
				[GlobalVars getVar].hostedRoom = [[Room alloc] initWithID:_roomField.text];
				[GlobalVars getVar].memberedRoom = [GlobalVars getVar].hostedRoom;
				
				[RiverAlertUtility showOKAlertWithMessage:responseText];
				
				[self.navigationController popViewControllerAnimated:YES];
			} else {
				
				[RiverAlertUtility showOKAlertWithMessage:responseText];
			}
		}
	}];

}

@end
