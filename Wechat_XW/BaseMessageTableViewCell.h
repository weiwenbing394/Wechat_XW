//
//  BaseMessageTableViewCell.h
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Messages;

//在从重用池出列时，修改的数据会作用到其他具有相同标识的待重用列上，所以需要用到两个标识避免数据错误
static NSString *const kCellIdentifierLeft = @"ChatroomIdentifierLeft";
static NSString* const kCellIdentifierRight = @"ChatroomIdentifierRight";

typedef NS_ENUM(NSUInteger,MessageAlignement) {
    MessageAlignementUndefined,
    MessageAlignementLeft,
    MessageAlignementRight
};

@interface BaseMessageTableViewCell : UITableViewCell
//消息内容对齐方式
@property (nonatomic,assign)MessageAlignement alignement;
//消息model
@property (nonatomic,strong)Messages *model;
//消息气泡
@property (nonatomic,strong)UIImageView *bubbleView;
//创建uitableviewcell
- (void)buildCell;
//更改视图约束
- (void)bindConstraints;
//长按
- (void)longPressOnBubble:(UILongPressGestureRecognizer*)press;
@end
