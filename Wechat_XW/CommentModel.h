//
//  CommentModel.h
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/9.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
///评论说说的id
@property(nonatomic,copy)NSString *commentId;
//发表评论的用户id
@property(nonatomic,copy)NSString *commentUserId;
//发表评论的用户姓名
@property(nonatomic,copy)NSString *commentUserName;
//发表评论的用户图片
@property(nonatomic,copy)NSString *commentPhoto;
//发表的评论类容
@property(nonatomic,copy)NSString *commentText;
//发表说说的用户id
@property(nonatomic,copy)NSString *commentByUserId;
//发表说说的用户姓名
@property(nonatomic,copy)NSString *commentByUserName;
//发表说说的用户图片
@property(nonatomic,copy)NSString *commentByPhoto;
//发表评论的时间
@property(nonatomic,copy)NSString *createDateStr;

@property(nonatomic,copy)NSString *checkStatus;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end
