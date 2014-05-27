//
//  UILabel+MGCustomFont.m
//  River
//
//  Created by Matthew Gardner on 5/4/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "UILabel+MGCustomFont.h"

@implementation UILabel (MGCustomFont)

- (NSString *)fontName {
    return self.font.fontName;
}

- (void)setFontName:(NSString *)fontName {
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}

@end
