//
//  RiverViewController.m
//  River
//
//  Created by Matthew Gardner on 4/27/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverViewController.h"
#import "SWRevealViewController.h"
#import "RiverSPLoginViewController.h"

@interface RiverViewController ()

@end

@implementation RiverViewController

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
	
	// Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
	
    // Configure the reveal menu button
    [self.revealBarButton addTarget:self action:@selector(resignResponderAndRevealToggle) forControlEvents:UIControlEventTouchUpInside];
	[[self.revealBarButton viewWithTag:0] setContentMode:UIViewContentModeCenter];
	
	if ([self isKindOfClass:[RiverSPLoginViewController class]])
		[[UITextField appearance] setTintColor:kRiverFGDarkGray];
	else
		[[UITextField appearance] setTintColor:kRiverLightBlue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resignResponderAndRevealToggle {
	[self.view endEditing:YES];
	[self.revealViewController revealToggleAnimated:YES];
}

- (IBAction)backPressed:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	
	
	return YES;
}

@end
