//
//  CameraAndPhotoPicker.h
//  Wechat_XW
//
//  Created by 大家保 on 2017/2/8.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>
//拍摄
typedef void (^CameraBlock) (UIImage *selectedImage);
//从相册获取
typedef void (^PhotoBlock) (UIImage *selecteImage);
//失败
typedef void (^faildBlock) ();


@interface CameraAndPhotoPicker : NSObject
//拍摄
@property (nonatomic,copy)CameraBlock cameraBlock;
//从相册获取
@property (nonatomic,copy)PhotoBlock photoBlock;

@property (nonatomic,copy)NSString *str;

+ (CameraAndPhotoPicker *)shareCameraAndPhotoPicker;
//拍摄
- (void)getPhotoWithCamera:(CameraBlock)camerablock editing:(BOOL) canEditing faild:(faildBlock)faild showIn:(UIViewController *)controller;
//从相册获取
- (void)getPhotoWithPhotoLib:(PhotoBlock)phontoblock editing:(BOOL) canEditing faild:(faildBlock)faild showIn:(UIViewController *)controller;

@end
