//
//  MainViewController.h
//  CollabStream
//
//  Created by Matthew Gardner on 1/22/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiverViewController.h"
#import "RiverAuthAccount.h"
#import "AddSongTableViewController.h"

@interface AddSongViewController : RiverViewController <UITextFieldDelegate, UIGestureRecognizerDelegate> {
	
	bool tracksFetched, artistsFetched, albumsFetched;
	
	AddSongTableViewController *resultsTVC;
	
	unsigned int selectedRow;
}

@property (strong, nonatomic) NSArray *trackResults;
@property (strong, nonatomic) NSArray *artistResults;
@property (strong, nonatomic) NSArray *albumResults;

// UI
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *songsButton;
@property (weak, nonatomic) IBOutlet UIButton *artistsButton;
@property (weak, nonatomic) IBOutlet UIButton *albumsButton;
@property (weak, nonatomic) IBOutlet UILabel *searchPlaceholderLabel;

- (void)searchSpotify:(NSString *)searchText;
- (IBAction)songsPressed:(id)sender;
- (IBAction)artistsPressed:(id)sender;
- (IBAction)albumsPressed:(id)sender;

@end
