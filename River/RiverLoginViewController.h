//
//  RiverLoginViewController.h
//  River
//
//  Created by Matthew Gardner on 9/7/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiverViewController.h"

@interface RiverLoginViewController : RiverViewController

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)loginPressed:(id)sender;

@end
