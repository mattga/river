//
//  AddSongTableViewController.h
//  River
//
//  Created by Matthew Gardner on 5/8/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiverTableViewController.h"
#import "ResultsAlbumTableViewCell.h"
#import "ResultsArtistTableViewCell.h"
#import "ResultsSongTableViewCell.h"

@interface AddSongTableViewController : UITableViewController {
	
}

@property (nonatomic) unsigned int selectedRow;

// Passed data
@property (nonatomic) NSInteger selectedTab;
@property (nonatomic, strong) NSMutableArray *trackResults;
@property (nonatomic, strong) NSMutableArray *artistResults;
@property (nonatomic, strong) NSMutableArray *albumResults;

@end
