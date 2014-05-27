//
//  DiscoverRoomViewController.m
//  River
//
//  Created by Matthew Gardner on 2/22/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "DiscoverRoomViewController.h"

@interface DiscoverRoomViewController ()

@end

@implementation DiscoverRoomViewController
{
    //Get roomNames from server and put it in this NSArray
    //NSArray *roomNames;
    
    NSDictionary *groupNames;
    NSMutableArray *mutableRoomNames;
    
    //Get roomDescriptions from server and put it in this NSArray
    //NSArray *roomDescriptions;
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embedDiscoverTable"]) {
		
	}
}


@end
