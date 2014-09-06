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
	
    // Register KVO on synchronizer background thread
    appDelegate = (RiverAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self addObserver:self forKeyPath:@"appDelegate.syncId" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"appDelegate.syncId"]) {
		[(RiverViewController*)self performSelectorOnMainThread:@selector(updateFooter) withObject:nil waitUntilDone:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"appDelegate.syncId"];
}

- (IBAction)discoverSelected:(id)sender {
	[_discoverButton setBackgroundColor:kRiverLightBlue];
	[_discoverButton setTitleColor:kRiverBGLightGray forState:UIControlStateNormal];
	
	[_joinButton setBackgroundColor:kRiverBGLightGray];
	[_joinButton setTitleColor:kRiverLightBlue forState:UIControlStateNormal];
	
	[_discoverContainer setHidden:NO];
	[_joinContainer setHidden:YES];
	
	[discoverTVC.tableView reloadData];
}

- (IBAction)joinSelected:(id)sender {
	[_joinButton setBackgroundColor:kRiverLightBlue];
	[_joinButton setTitleColor:kRiverBGLightGray forState:UIControlStateNormal];
	
	[_discoverButton setBackgroundColor:kRiverBGLightGray];
	[_discoverButton setTitleColor:kRiverLightBlue forState:UIControlStateNormal];
	
	[_joinContainer setHidden:NO];
	[_discoverContainer setHidden:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embedDiscoverTable"]) {
		discoverTVC = segue.destinationViewController;
	}
}


@end
