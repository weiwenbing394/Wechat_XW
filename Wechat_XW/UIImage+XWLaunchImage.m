//
//  UIImage+XWLaunchImage.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/13.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "UIImage+XWLaunchImage.h"

@implementation UIImage (XWLaunchImage)
//获得启动图片
+ (UIImage *)getLaunchImage{
    UIViewController *viewController=[[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    UIImageView *imageView=viewController.view.subviews[0];
    return imageView.image;
}

@end
