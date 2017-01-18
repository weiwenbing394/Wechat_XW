//
//  CoverHeaderView.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/18.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "CoverHeaderView.h"

@interface CoverHeaderView ()

@end

@implementation CoverHeaderView

+ (instancetype)coverHeaderWithCover:(UIImage*)cover avatar:(UIImage*)avatar name:(NSString*)name{
    CoverHeaderView* view =[[[NSBundle mainBundle] loadNibNamed:@"CoverHeaderView" owner:nil options:nil] lastObject];
    view.translatesAutoresizingMaskIntoConstraints = false;
    view.coverImageView.image = cover;
    view.nameLabel.text = name;
    view.avatarButton.layer.borderWidth = 1;
    view.avatarButton.layer.borderColor =
    [UIColor colorWithWhite:0.95 alpha:1].CGColor;
    [view.avatarButton setImage:avatar forState:UIControlStateNormal];
    return view;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.frame = self.bounds;
}


@end
