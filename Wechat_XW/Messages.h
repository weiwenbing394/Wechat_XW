//
//  Messages.h
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Messages : NSObject

@property (nonatomic) float height;

@property (nullable, nonatomic, retain) NSString *message;

@property (nonatomic) int16_t messageType;

@property (nonatomic) int64_t sender;

@property (nonatomic) NSTimeInterval sendTime;

@property (nonatomic) BOOL showSendTime;

@end
