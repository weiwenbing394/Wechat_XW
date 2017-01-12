//
//  FriendModel.h
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/12.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject
//图片
@property(nonatomic,copy)NSString *photo;
//姓名
@property(nonatomic,copy)NSString *userName;
//用户id
@property(nonatomic,copy)NSString *userId;
//手机号
@property(nonatomic,copy)NSString *phoneNO;
//初始化方法
-(instancetype)initWithDic:(NSDictionary *)dic;

@end
