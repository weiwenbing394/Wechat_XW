//
//  XWLaunchViewManager.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/13.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "XWLaunchViewManager.h"
#import "XWAdModel.h"
#import "XWLaunchView.h"
#import "UIImage+XWLaunchImage.h"
#import "XWAdViewController.h"
//广告倒计时间 单位：秒
#define DURATION 5

@interface XWLaunchViewManager ()
//启动视图
@property (nonatomic,weak)XWLaunchView *launchView;
//定时器
@property (nonatomic,strong)dispatch_source_t timer;

@end

@implementation XWLaunchViewManager

/**
 创建一个对象
 */
+(instancetype)launchViewManger{
    return [[[self class] alloc]init];
};


/**
 展示对象
 */
-(void)showView:(UIView *)view{
    self.frame=view.bounds;
    [view addSubview:self];
    [self addADLaunchView];
    [self loadData];
};

- (void)addADLaunchView{
    XWLaunchView *adLaunchView=[[XWLaunchView alloc]init];
    if (self.adViewType==ADViewTypeAllScreen) {
        adLaunchView.imageSizeType=AllScreen;
    }else{
        adLaunchView.imageSizeType=HalfScreen;
    }
    adLaunchView.skipBtn.hidden=YES;
    adLaunchView.launchImageView.image=[UIImage getLaunchImage];
    adLaunchView.frame=self.bounds;
    [adLaunchView.skipBtn addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:adLaunchView];
    _launchView=adLaunchView;
}

- (void)loadData{
    if (_adModel.launchUrl&&_adModel.launchUrl.length>0) {
        _launchView.adImageView.image=[UIImage imageWithContentsOfFile:_adModel.launchUrl];
         // 启动倒计时
         [self scheduledGCDTimer];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushAdController)];
        [_launchView addGestureRecognizer:tap];
    }else{
        [self dismissController];
    }
}

- (void)scheduledGCDTimer{
    [self cancleGCDTimer];
    __block int timeLeave = DURATION; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    __typeof (self) __weak weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        if(timeLeave <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(weakSelf.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //关闭界面
                [self dismissController];
            });
        }else{
            int curTimeLeave = timeLeave;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面
                [weakSelf showSkipBtnTitleTime:curTimeLeave];
                
            });
            --timeLeave;
        }
    });
    dispatch_resume(_timer);
}

- (void)showSkipBtnTitleTime:(int)timeLeave{
    NSString *timeLeaveStr = [NSString stringWithFormat:@"跳过 %ds",timeLeave];
    [_launchView.skipBtn setTitle:timeLeaveStr forState:UIControlStateNormal];
    _launchView.skipBtn.hidden = NO;
}

- (void)cancleGCDTimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}


- (void)dismissController{
    [self cancleGCDTimer];
    //消失动画
    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //缩放修改处
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


-(void)pushAdController{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cancleGCDTimer];
        [self removeFromSuperview];
        XWAdViewController * adVc=[[XWAdViewController alloc]init];
        adVc.adModel=self.adModel;
        if (self.progressColor) {
            adVc.progressColor=self.progressColor;
        }
        adVc.hidesBottomBarWhenPushed=YES;
        [[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers[0] pushViewController:adVc animated:YES];
    });
}


- (void)dealloc{
    [self cancleGCDTimer];
}

@end
