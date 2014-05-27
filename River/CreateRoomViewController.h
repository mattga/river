//
//  CreateRoomViewController.h
//  River
//
//  Created by Matthew Gardner on 2/23/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiverFrontViewController.h"
#import "CocoaLibSpotify.h"

@interface CreateRoomViewController : RiverFrontViewController

@property (strong, nonatomic) IBOutlet UITextField *roomField;
@property (strong, nonatomic) IBOutlet UIButton *createButton;

- (IBAction)createPressed:(id)sender;

@end
