//
//  XWLaunchView.h
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/13.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
//跳过按钮宽
#define kSkipBtnWidth 65
//跳过按钮高
#define kSkipBtnHeight 30
//跳过按钮右边距
#define kSkipRightEdging 20
//跳过按钮顶部边距
#define kSkipTopEdging 40
//HalfScreen广告页面高度
#define kAdImageViewHeightHalf kScreenHeight-100
//AllScreen广告页面高度
#define kAdImageViewHeightAll  kScreenHeight

typedef NS_ENUM(NSInteger ,ImageSizeType) {
    AllScreen,
    HalfScreen
};

@interface XWLaunchView : UIView
//启动图片
@property (nonatomic, weak) UIImageView *launchImageView;
//广告图片
@property (nonatomic, weak) UIImageView *adImageView;
//跳过button
@property (nonatomic, weak) UIButton *skipBtn;
//图片显示样式
@property (nonatomic, assign)ImageSizeType imageSizeType;

@end
