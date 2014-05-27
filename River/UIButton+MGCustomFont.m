//
//  UIButton+MGCustomFont.m
//  River
//
//  Created by Matthew Gardner on 5/4/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "UIButton+MGCustomFont.h"

@implementation UIButton (MGCustomFont)

- (NSString *)fontName {
    return self.titleLabel.font.fontName;
}

- (void)setFontName:(NSString *)fontName {
    self.titleLabel.font = [UIFont fontWithName:fontName size:self.titleLabel.font.pointSize];
}

@end
