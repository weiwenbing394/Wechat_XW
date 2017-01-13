//
//  XWLaunchViewManager.h
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/13.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWAdModel;

typedef NS_ENUM(NSInteger, ADViewType) {
    //广告图片全屏显示
    ADViewTypeAllScreen,
    //广告图片高度为全屏幕减100
    ADviewTypeScale
};

@interface XWLaunchViewManager : UIView
/** 广告模型*/
@property (nonatomic, strong) XWAdModel *adModel;
/** 广告图片启动样式*/
@property (nonatomic, assign) ADViewType adViewType;
/** webview进度颜色*/
@property (nonatomic,strong)  UIColor *progressColor;
/** 创建一个对象*/
+(instancetype)launchViewManger;
/**展示对象*/
-(void)showView:(UIView *)view;
@end
