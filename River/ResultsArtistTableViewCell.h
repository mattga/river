//
//  RestultsArtistTableViewCell.h
//  River
//
//  Created by Matthew Gardner on 5/8/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsArtistTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;
@property (weak, nonatomic) IBOutlet UIImageView *artistSelectedImage;
@property (weak, nonatomic) IBOutlet UIImageView *artistSPImage;

@end
