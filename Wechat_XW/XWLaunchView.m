//
//  XWLaunchView.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/13.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "XWLaunchView.h"

@implementation XWLaunchView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addlaunchImageView];
        [self addAdImageView];
        [self addSkipBtn];
    }
    return self;
}

- (void)addlaunchImageView{
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    _launchImageView = imageView;
}

- (void)addAdImageView{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    _adImageView = imageView;
}

- (void)addSkipBtn
{
    UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    skipBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    skipBtn.titleLabel.textColor = [UIColor whiteColor];
    skipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    skipBtn.alpha = 0.92;
    skipBtn.layer.cornerRadius = 4.0;
    skipBtn.clipsToBounds = YES;
    [self addSubview:skipBtn];
    _skipBtn = skipBtn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _launchImageView.frame = self.bounds;
    _adImageView.frame = self.imageSizeType==AllScreen? CGRectMake(0, 0, kScreenWidth, kAdImageViewHeightAll):CGRectMake(0, 0, kScreenWidth, kAdImageViewHeightHalf);
    _skipBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - kSkipBtnWidth - kSkipRightEdging, kSkipTopEdging, kSkipBtnWidth, kSkipBtnHeight);
}


@end
