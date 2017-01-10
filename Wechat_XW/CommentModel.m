//
//  CommentModel.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/9.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.commentId          = dic[@"commentId"];
        self.commentUserId      = dic[@"commentUserId"];
        self.commentUserName    = dic[@"commentUserName"];
        self.commentPhoto       = dic[@"commentPhoto"];
        self.commentText        = dic[@"commentText"];
        self.commentByUserId    = dic[@"commentByUserId"];
        self.commentByUserName  = dic[@"commentByUserName"];
        self.commentByPhoto     = dic[@"commentByPhoto"];
        self.createDateStr      = dic[@"createDateStr"];
        self.checkStatus        = dic[@"checkStatus"];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
