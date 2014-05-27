//
//  RiverViewController.h
//  River
//
//  Created by Matthew Gardner on 4/27/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "RiverAlertUtility.h"

@interface RiverViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *revealBarButton;

- (IBAction)backPressed:(id)sender;

@end
