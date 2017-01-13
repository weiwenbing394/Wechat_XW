//
//  AppDelegate.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/6.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "AppDelegate.h"
#import "XWLaunchViewManager.h"
#import "XWAdModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    [self addADLaunchView];
    return YES;
}

//启动页加载广告
- (void)addADLaunchView{
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *filePath=[self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    //图片存在
    if (isExist) {
            XWAdModel * adModel=[[XWAdModel alloc]init];
            adModel.launchUrl=filePath;
            adModel.addetailUrl=[kUserDefaults valueForKey:adDetailUrl];
            XWLaunchViewManager *launchView = [XWLaunchViewManager launchViewManger];
            launchView.adModel=adModel;
            launchView.adViewType=ADViewTypeAllScreen;
            launchView.progressColor=[UIColor lightGrayColor];
            [launchView showView:self.window.rootViewController.view];
    }
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    [self getAdvertisingImage];
}
/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName{
    if (imageName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        return filePath;
    }
    return nil;
}

/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage{
    // 这里原本采用美团的广告接口，现在用一些固定的图片url代替
    NSArray *imageArray = @[@"http://www.pp3.cn/uploads/201502/2015020213.jpg",@"http://s9.knowsky.com/bizhi/l/15001-25000/200952942732235752463.jpg",@"http://d.hiphotos.baidu.com/image/pic/item/f7246b600c3387444834846f580fd9f9d72aa034.jpg"];
    //图片详情地址集合测试用
    NSArray *detailUrlArray=@[@"http://www.baidu.com",@"http://www.sina.com"];
    //图片地址
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
    //详情地址
    NSString *detailUrl= detailUrlArray[arc4random() % detailUrlArray.count];
    //获取图片名
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist){
        // 如果该图片不存在，则删除老图片，下载新图片
        [self downloadAdImageWithUrl:imageUrl imageName:imageName detailUrl:detailUrl];
    }
}

/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName detailUrl:(NSString *)detailUrl{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        // 保存文件的名称
        NSString *filePath = [self getFilePathWithImageName:imageName];
        // 保存成功
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults setValue:detailUrl forKey:adDetailUrl];
            [kUserDefaults synchronize];
        }
    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
