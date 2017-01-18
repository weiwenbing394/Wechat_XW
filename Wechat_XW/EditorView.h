//
//  EditorView.h
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,ChatMessageType) {
    /* 文本信息 */
    ChatMessageTypeText,
    /* 图片信息 */
    ChatMessageTypeImage,
    /* 语音信息 */
    ChatMessageTypeVoice
};

@interface EditorView : UIView

+ (instancetype)editor;

@property (nonatomic, copy) void (^keyboardWasShown)(NSInteger animCurveKey, CGFloat duration, CGSize keyboardSize);

@property (nonatomic, copy) void (^keyboardWillBeHidden)(NSInteger animCurveKey, CGFloat duration, CGSize keyboardSize);

@property (nonatomic, copy) void (^messageWasSend)(id message, ChatMessageType type);

@end
