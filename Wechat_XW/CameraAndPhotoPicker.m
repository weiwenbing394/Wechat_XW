//
//  CameraAndPhotoPicker.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/2/8.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "CameraAndPhotoPicker.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>

@interface CameraAndPhotoPicker ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,strong)UIImagePickerController *picker;

@end

@implementation CameraAndPhotoPicker

+ (CameraAndPhotoPicker *)shareCameraAndPhotoPicker{
    static CameraAndPhotoPicker *cameraAndPhotoPicker=nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (cameraAndPhotoPicker==nil) {
            cameraAndPhotoPicker=[[CameraAndPhotoPicker alloc]init];
        }
    });
    return cameraAndPhotoPicker;
};

//拍摄
- (void)getPhotoWithCamera:(CameraBlock)camerablock editing:(BOOL) canEditing faild:(faildBlock)faild showIn:(UIViewController *)controller{
    self.cameraBlock=camerablock;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        faild();
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self beiginTakePhoto:canEditing showIn:controller];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    faild();
                });
            }
        }];
    }else if(authStatus == AVAuthorizationStatusAuthorized){
        [self beiginTakePhoto:canEditing showIn:controller];
    }
};

//开始拍摄
- (void)beiginTakePhoto:(BOOL) canEditing showIn:(UIViewController *)controller{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {//真机调试
        self.picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        self.picker.showsCameraControls=YES;
    }else{  //模拟器
        self.picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    self.picker.allowsEditing=canEditing;
    if (controller==nil) {
        controller=[[UIApplication sharedApplication]delegate].window.rootViewController;
    }
    [controller presentViewController:self.picker animated:YES completion:nil];
}


//从相册获取
- (void)getPhotoWithPhotoLib:(PhotoBlock)phontoblock editing:(BOOL) canEditing faild:(faildBlock)faild showIn:(UIViewController *)controller{
    self.photoBlock=phontoblock;
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        faild();
    }else if(author == ALAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
                dispatch_async(dispatch_get_main_queue(), ^{
                   faild();
                });
            }else if (status == PHAuthorizationStatusAuthorized){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getPhotosFromLibrary:canEditing showIn:controller];
                });
            }
        }];
    }else if(author == ALAuthorizationStatusAuthorized){
        [self getPhotosFromLibrary:canEditing showIn:controller];
    }
};

//开始读取
- (void)getPhotosFromLibrary :(BOOL) canEditing showIn:(UIViewController *)controller{
    self.picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.picker.allowsEditing=canEditing;
    if (controller==nil) {
        controller=[[UIApplication sharedApplication]delegate].window.rootViewController;
    }
    [controller presentViewController:self.picker animated:YES completion:nil];
}


#pragma mark delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    @autoreleasepool {
        NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
        //如果是视频
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *image;
            //如果允许编辑则获得编辑后的照片，否则获取原始照片
            if (self.picker.allowsEditing) {
                image=[info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
            }else{
                image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
            }
            if (image) {
                //压缩图片
                NSData *fileData = UIImageJPEGRepresentation(image, 1.0);
                self.cameraBlock([UIImage imageWithData:fileData]);
            }
        }else{
            //如果是视频
            NSURL *url = info[UIImagePickerControllerMediaURL];
            NSLog(@"视频路径：%@",url);
        }
    }
    [self.picker dismissViewControllerAnimated:YES completion:nil];
};



#pragma mark 懒加载
- (UIImagePickerController *)picker{
    if (!_picker) {
        _picker=[[UIImagePickerController alloc]init];
        _picker.delegate = self;
    }
    return _picker;
}


- (void)dealloc{
    if (self.picker) {
       self.picker=nil;
    }
}

@end
