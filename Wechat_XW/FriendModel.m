//
//  FriendModel.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/12.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "FriendModel.h"

@implementation FriendModel

//初始化方法
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.userId      = dic[@"userId"];
        self.userName    = dic[@"userName"];
        self.photo       = dic[@"photo"];
        self.phoneNO     = dic[@"phoneNO"];
    }
    return self;
};

//找不到的key在这里
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
