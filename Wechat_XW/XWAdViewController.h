//
//  XWAdViewController.h
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/13.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWAdModel;

@interface XWAdViewController : UIViewController

/** 广告模型*/
@property (nonatomic, strong) XWAdModel *adModel;

@property (nonatomic, strong) UIColor *progressColor;


@end
