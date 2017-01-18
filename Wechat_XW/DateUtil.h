//
//  DateUtil.h
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+ (NSDateFormatter *)sharedDateFormatter;

//字符串转nsdate
+ (NSDate *)stringToDate:(NSString *)dateStr format:(NSString *)format;

//nsdate转字符串
+ (NSString *)dateString:(NSDate *)date withFormat:(NSString *)format;

//获取当前时间标识
+ (NSString *)dateIdentifierNow;

//从一个格式的时间字符串转到另一个格式的时间字符串
+ (NSString *)dateString:(NSString *)originalStr fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat;

//获取尽量短的本地化时间字符串
+ (NSString *)localizedShortDateString:(NSDate *)date;

+ (NSString*)localizedShortDateStringFromInterval:(NSTimeInterval)interval;

@end
