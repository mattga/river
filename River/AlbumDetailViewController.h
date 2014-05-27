//
//  AlbumDetailViewController.h
//  River
//
//  Created by Matthew Gardner on 3/10/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiverViewController.h"
#import "RiverAuthAccount.h"
#import "AlbumTracksTableViewController.h"

@interface AlbumDetailViewController : RiverViewController {
	AlbumTracksTableViewController *tracksTVC;
}

// Passed data
@property (strong, nonatomic) NSDictionary *album;
@property (strong, nonatomic) NSMutableArray *tracks;

@property (weak, nonatomic) IBOutlet UILabel *albumInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumArtImage;

@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;

@end