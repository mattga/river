//
//  SlideMenuTableViewCell.m
//  River
//
//  Created by Matthew Gardner on 5/18/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "SideMenuTableViewCell.h"

@implementation SideMenuTableViewCell

static SideMenuTableViewCell *selectedCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
	_selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	[_selectedView setBackgroundColor:kRiverBGLightGray];
	
	CGRect labelFrame = CGRectMake(_menuItemLabel.frame.origin.x, _menuItemLabel.frame.origin.y, _menuItemLabel.frame.size.width, _menuItemLabel.frame.size.height);
	CGRect imageFrame = CGRectMake(_image.frame.origin.x, _image.frame.origin.y, _image.frame.size.width, _image.frame.size.height);
	
	UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
	label.font = [UIFont fontWithName:kGothamBold size:_menuItemLabel.font.pointSize];
	label.text = _menuItemLabel.text;
	label.textColor = kRiverLightBlue;
	
	UIImageView *image = [[UIImageView alloc] initWithFrame:imageFrame];
	switch (_image.tag) {
		case 0:
			image.image = [UIImage imageNamed:@"btn_menu_home_lightblue"];
			break;
		case 1:
			image.image = [UIImage imageNamed:@"btn_menu_host_lightblue"];
			break;
		case 2:
			image.image = [UIImage imageNamed:@"btn_menu_join_lightblue"];
			break;
		case 3:
			image.image = [UIImage imageNamed:@"btn_menu_discover_lightblue"];
			break;
		case 4:
			image.image = [UIImage imageNamed:@"btn_menu_create_lightblue"];
			break;
		case 5:
			image.image = [UIImage imageNamed:@"btn_menu_settings_lightblue"];
			break;
	}
	
	[_selectedView addSubview:label];
	[_selectedView addSubview:image];
	
	if (selectedCell == nil) {
		selectedCell = self;
		[self setSelected:YES animated:NO];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
	if (selected) {
		[selectedCell.selectedView removeFromSuperview];
		
		[self.contentView addSubview:_selectedView];
		selectedCell = self;
	}
}

@end
