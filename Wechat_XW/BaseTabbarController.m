//
//  BaseTabbarController.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/12.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "BaseTabbarController.h"

@interface BaseTabbarController ()<UITabBarControllerDelegate>

@end

@implementation BaseTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.delegate=self;
}

//拦截tabbarController的点击事件
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    if ([tabBarController.viewControllers indexOfObject:viewController]==1) {
//        NSLog(@"拦截了");
//        return NO;
//        
//    }else{
//        return YES;
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
