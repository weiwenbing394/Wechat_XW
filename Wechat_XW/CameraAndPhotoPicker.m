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
- (void)getPhotoWithCamera:(CameraBlock)camerablock editing:(BOOL) canEditing faild:(faildBlock)faild{
    self.cameraBlock=camerablock;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        faild();
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {//真机调试
            self.picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            self.picker.showsCameraControls=YES;
        }else{  //模拟器
            self.picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        self.picker.allowsEditing=canEditing;
        
        [[[UIApplication sharedApplication]delegate].window.rootViewController presentViewController:self.picker animated:YES completion:nil];
    }
};


//从相册获取
- (void)getPhotoWithPhotoLib:(PhotoBlock)phontoblock editing:(BOOL) canEditing faild:(faildBlock)faild{
    self.photoBlock=phontoblock;
    ALAuthorizationStatus author=[ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        faild();
    }else{
        self.picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        self.picker.allowsEditing=canEditing;
        [[[UIApplication sharedApplication]delegate].window.rootViewController presentViewController:self.picker animated:YES completion:nil];
    }
};


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
    NSLog(@"释放了");
    if (self.picker) {
       self.picker=nil;
    }
}

@end
