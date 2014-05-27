//
//  ResultsAlbumTableViewCell.h
//  River
//
//  Created by Matthew Gardner on 5/8/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsAlbumTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *releasedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UIImageView *albumSelectedImage;
@property (weak, nonatomic) IBOutlet UIImageView *albumArtImage;

@end
