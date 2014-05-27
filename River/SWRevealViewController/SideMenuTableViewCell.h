//
//  SlideMenuTableViewCell.h
//  River
//
//  Created by Matthew Gardner on 5/18/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface SideMenuTableViewCell : UITableViewCell {
}

@property (strong, nonatomic) UIView *selectedView;

@property (weak, nonatomic) IBOutlet UILabel *menuItemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
