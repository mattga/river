//
//  MainViewController.h
//  CollabStream
//
//  Created by Matthew Gardner on 1/22/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiverViewController.h"
#import "SPAlbumsXMLParser.h"
#import "SPTracksXMLParser.h"
#import "SPArtistsXMLParser.h"
#import "RiverAuthAccount.h"
#import "AddSongTableViewController.h"

@interface AddSongViewController : RiverViewController <UITextFieldDelegate, UIGestureRecognizerDelegate> {
	NSMutableArray *trackResults;
	NSMutableArray *artistResults;
	NSMutableArray *albumResults;
	
	bool tracksFetched, artistsFetched, albumsFetched;
	
	AddSongTableViewController *resultsTVC;
	
	unsigned int selectedRow;
}

// UI
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *songsButton;
@property (weak, nonatomic) IBOutlet UIButton *artistsButton;
@property (weak, nonatomic) IBOutlet UIButton *albumsButton;
@property (weak, nonatomic) IBOutlet UILabel *songsLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistsLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumsLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchPlaceholderLabel;

- (void)searchSpotify:(NSString *)searchText;
- (IBAction)songsPressed:(id)sender;
- (IBAction)artistsPressed:(id)sender;
- (IBAction)albumsPressed:(id)sender;

@end
