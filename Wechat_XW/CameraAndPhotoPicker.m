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

//拍摄图片
- (void)getPhotoWithCamera:(PhotosBlock)camerablock editing:(BOOL) canEditing faild:(faildBlock)faild showIn:(UIViewController *)controller{
    self.photosBlock=camerablock;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        dispatch_async(dispatch_get_main_queue(), ^{
            faild();
        });
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

//开始拍摄图片
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


//从相册获取图片
- (void)getPhotoWithPhotoLib:(PhotosBlock)phontoblock editing:(BOOL) canEditing faild:(faildBlock)faild showIn:(UIViewController *)controller{
    self.photosBlock=phontoblock;
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        dispatch_async(dispatch_get_main_queue(), ^{
            faild();
        });
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

//开始读取图片
- (void)getPhotosFromLibrary :(BOOL) canEditing showIn:(UIViewController *)controller{
    self.picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.picker.allowsEditing=canEditing;
    if (controller==nil) {
        controller=[[UIApplication sharedApplication]delegate].window.rootViewController;
    }
    [controller presentViewController:self.picker animated:YES completion:nil];
}


//拍摄视频
- (void)getVideoFromCamera:(VideoBlock)videofromCameraBlock editing:(BOOL) canEditing faild:(faildBlock)faild showIn:(UIViewController *)controller{
    self.videoBlock=videofromCameraBlock;
    AVAuthorizationStatus  authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ([[AVAudioSession sharedInstance]respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted){
            if (granted) {
                if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        faild();
                    });
                }else if(authStatus == AVAuthorizationStatusNotDetermined){
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        if (granted) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self beiginTakeVideo:canEditing showIn:controller faild:faild];
                            });
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                faild();
                            });
                        }
                    }];
                }else if(authStatus == AVAuthorizationStatusAuthorized){
                    [self beiginTakeVideo:canEditing showIn:controller faild:faild];
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    faild();
                });
            }
        }];
    }
};

//开始摄像
- (void)beiginTakeVideo:(BOOL)canEditing  showIn:(UIViewController *)controller faild:(faildBlock)faild{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {//真机调试
        self.picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        NSArray * mediaTypes =[UIImagePickerController  availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        self.picker.mediaTypes=@[mediaTypes[1]];
        self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        self.picker.showsCameraControls=YES;
        self.picker.allowsEditing=canEditing;
        if (controller==nil) {
            controller=[[UIApplication sharedApplication]delegate].window.rootViewController;
        }
        [controller presentViewController:self.picker animated:YES completion:nil];
    }else{//不支持摄像
        dispatch_async(dispatch_get_main_queue(), ^{
            faild();
        });
    }
}

//从相册获取视频
- (void)getVideoFromLibaray:(VideoBlock)videofromLibararyBlock  editing:(BOOL) canEditing faild:(faildBlock)faild showIn:(UIViewController *)controller{
    self.videoBlock=videofromLibararyBlock;
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        dispatch_async(dispatch_get_main_queue(), ^{
            faild();
        });
    }else if(author == ALAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
                dispatch_async(dispatch_get_main_queue(), ^{
                    faild();
                });
            }else if (status == PHAuthorizationStatusAuthorized){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getVidelFromLibrary:canEditing showIn:controller];
                });
            }
        }];
    }else if(author == ALAuthorizationStatusAuthorized){
        [self getVidelFromLibrary:canEditing showIn:controller];
    }
};

//开始从相册读取视频资料
- (void)getVidelFromLibrary :(BOOL)canEditing showIn:(UIViewController *)controller{
    self.picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
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
        //如果是图片
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *image;
            //如果允许编辑则获得编辑后的照片，否则获取原始照片
            if (self.picker.allowsEditing) {
                image=[info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
            }else{
                image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
            }
            if (image) {
                //压缩图片(png格式)
                NSData *fileData;
                if (UIImagePNGRepresentation(image)) {
                    fileData=UIImagePNGRepresentation(image);
                }else{
                    fileData= UIImageJPEGRepresentation(image, 1.0);
                }
                //保存到本地
                if (picker.sourceType==UIImagePickerControllerSourceTypeCamera&&self.saveToLocal) {
                    UIImageWriteToSavedPhotosAlbum(image, self,  @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
                }
                self.photosBlock?self.photosBlock([UIImage imageWithData:fileData]):nil;
            }
        }else{
            //如果是视频
            NSString *videoPath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
            if (videoPath == nil) {
                NSLog(@"视频地址错误");
            }else{
                AVURLAsset* asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
                //视频长度
                CGFloat times = CMTimeGetSeconds([asset duration]);
                //视频宽高
                AVAssetTrack *asetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
                CGFloat videoHight = asetTrack.naturalSize.height;
                CGFloat videoWidth = asetTrack.naturalSize.width;
                //保存到本地
                if (picker.sourceType==UIImagePickerControllerSourceTypeCamera&&self.saveToLocal) {
                    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath)) {
                        //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
                        UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
                    }
                }
                self.videoBlock?self.videoBlock([NSURL fileURLWithPath:videoPath],times,videoWidth,videoHight):nil;
            }
        }
    }
    [self.picker dismissViewControllerAnimated:YES completion:nil];
};

//保存照片
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存照片失败");
    }else{
        NSLog(@"保存照片成功");
    }
}

//保存视频
- (void)video:(NSString *)videoStr didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频失败");
    }else{
        NSLog(@"保存视频成功");
    }
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

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
