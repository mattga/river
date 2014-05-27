//
//  JoinRoomViewController.h
//  River
//
//  Created by Matthew Gardner on 2/22/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiverFrontViewController.h"

@interface JoinRoomViewController : RiverFrontViewController

// UI
@property (strong, nonatomic) IBOutlet UITextField *roomField;
@property (strong, nonatomic) IBOutlet UIButton *joinButton;

- (IBAction)joinPressed:(id)sender;

@end
