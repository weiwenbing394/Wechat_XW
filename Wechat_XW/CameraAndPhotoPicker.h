//
//  CameraAndPhotoPicker.h
//  Wechat_XW
//
//  Created by 大家保 on 2017/2/8.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>
//图片
typedef void (^PhotosBlock) (UIImage *selectedImage);
//拍摄视频
typedef void (^VideoBlock) (NSURL *videoUrl,CGFloat times,CGFloat videoWidth,CGFloat videoHeight);
//失败
typedef void (^faildBlock) ();



@interface CameraAndPhotoPicker : NSObject
//图片
@property (nonatomic,copy)PhotosBlock photosBlock;
//拍摄视频
@property (nonatomic,copy)VideoBlock videoBlock;
//保存到本地
@property (nonatomic,assign)BOOL saveToLocal;
//是否使用自定义相机
@property (nonatomic,assign)BOOL useCustomCamera;

+ (CameraAndPhotoPicker *)shareCameraAndPhotoPicker;
//拍摄图片
- (void)getPhotoWithCamera:(PhotosBlock)camerablock editing:(BOOL) canEditing faild:(faildBlock)faild showIn:(UIViewController *)controller;
//从相册获取图片
- (void)getPhotoWithPhotoLib:(PhotosBlock)phontoblock editing:(BOOL) canEditing faild:(faildBlock)faild showIn:(UIViewController *)controller;
//拍摄视频
- (void)getVideoFromCamera:(VideoBlock)videofromCameraBlock editing:(BOOL) canEditing faild:(faildBlock)faild showIn:(UIViewController *)controller;
//从相册获取视频
- (void)getVideoFromLibaray:(VideoBlock)videofromLibararyBlock editing:(BOOL) canEditing faild:(faildBlock)faild showIn:(UIViewController *)controller;

@end
