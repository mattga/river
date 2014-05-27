//
//  ArtistDetailTableViewController.h
//  River
//
//  Created by Matthew Gardner on 3/10/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtistAlbumsTableViewController.h"
#import "RiverAuthAccount.h"
#import "RiverViewController.h"

@interface ArtistDetailViewController : RiverViewController {
	ArtistAlbumsTableViewController *albumsTVC;
}

@property (strong, nonatomic) NSDictionary *artist;
@property (strong, nonatomic) NSMutableArray *albums;

@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;

@end
